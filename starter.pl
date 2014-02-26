#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;

use Pod::Usage;
use Getopt::Long;
use autobox;
use autobox::Core;

use ExtUtils::MakeMaker qw(prompt);

use Text::MicroTemplate;
use Path::Class qw/dir file/;
use File::Copy;
use File::HomeDir;
use YAML;
use Data::Dumper;
sub p ($) { print Dumper shift }

use Cwd;
sub cd ($&) {
	my ($dir, $block) = @_;
	my $cd = cwd();
	chdir $dir;
	my $ret = $block->();
	chdir $cd;
	return $ret;
}

GetOptions(\my %opts, qw/help/);

$opts{help} && pod2usage(0);

unless (@ARGV == 1) {
	pod2usage(0);
	exit 1;
}

sub copy_templates_to_dist {
	my ($template_dir, $dist, $opts) = @_;
	my $rule      = $opts->{rule};
	my $vars      = $opts->{vars};

	$template_dir = dir($template_dir)->absolute;;
	$dist         = dir($dist);

	$template_dir->recurse( callback => sub {
		my ($file) = @_;

		my $path = $file->relative($template_dir);

		if (!$file->is_dir) {
			for my $key (keys %{ $rule->{path} }) {
				$path =~ s/$key/$rule->{path}->{$key}/ge;
			}
			$path =~ s/^\Q$template_dir\E/$dist/;
			$path = file($path);

			my $target = $dist->file($path);

			$target->dir->mkpath(1);
			say "$target <- $file";
			copy($file, $target);

			my $content = $target->slurp;
			for my $key (keys %{ $rule->{content} }) {
				$content =~ s/$key/$rule->{content}->{$key}/ge;
			}
			my $fh = $target->openw;
			my $rr = do {
				my $mt = Text::MicroTemplate->new( template => $content );
				my $cc = $mt->code;
				eval qq{
					sub {
						local \$_ = shift;
						$cc->();
					}
				};
			};
			print $fh $rr->($vars);
			$fh->close;
		}
	} );

}

sub execute_startup {
	my ($dist) = @_;

	my $startup = dir($dist)->file("startup.sh")->absolute;
	if (-e $startup) {
		cd $dist, sub {
			!system "/bin/sh $startup" or die $?;
		};
		$startup->remove();
	}
}

sub select_templates {
	my $global = file(__FILE__)->dir->absolute->subdir('templates');
	my $local  = dir(File::HomeDir->my_home)->subdir('.starter', 'templates');
	say "Global templates: $global";
	say "Local templates: $local";

	my $templates = [];

	for my $dir ($local, $global) {
		(-e "$dir") || next;

		my $tmpls = [];
		for my $f ($dir->children) {
			next unless $f->is_dir;

			$f = file($f);

			if ($f->basename eq 'default') {
				# $tmpls->unshift(file($f));
				unshift @$tmpls, file($f);
			} else {
				$tmpls->push(file($f));
			}
		}

		$templates->push(@$tmpls);
	}

	@$templates or die "templates not found";

	for (1..@$templates) {
		my $template = $templates->[$_-1];
		my $dispname = $template->basename;
		$dispname .= ' (.starter)' if $template =~ /\.starter/;
		say sprintf "[%d]: %s", $_, $dispname;
	}
	my $selected = prompt('Select:', '1');

	$templates->[$selected-1]->cleanup;
}

my $module    = [ @ARGV ]->shift;
my $pkg       = $module->split("::");
my $dist      = $pkg->join("-");
my $path      = $pkg->join("/") . ".pm";
my $appprefix = join '_', map lc, @$pkg;
my $opts      = {
	rule => {
		path => {
			MyApp  => $pkg->join("/"),
			myapp  => $appprefix,
			MyName => $pkg->join("-"),
			myname => $appprefix,
		},
		content => {
			MyApp  => $pkg->join("::"),
			myapp  => $appprefix,
			MyName => $pkg->join("::"),
			myname => $appprefix,
		},
	},
	vars => {
		'module'    => $module,
		'name'      => $module,
		'pkg'       => $pkg,
		'dist'      => $dist,
		'path'      => $path,
	},
};

warn Dumper $opts ;

my $template = select_templates();
if ($template) {
	say "Selected $template";
} else {
	say "No template selected";
	exit 1;
}

copy_templates_to_dist($template, $dist, $opts);

execute_startup($dist);

__END__

=head1 NAME

starter.pl - Create App Skelton

=head1 SYNOPSIS

  $ starter.pl MyApp

=head1 DESCRIPTION

  Execute startup.sh under template root directory after creating target app.

=cut

