package <?= $_->{module} ?>;

use strict;
use warnings;
use Exporter::Lite;
our @EXPORT = qw(config model);

use UNIVERSAL::require;
use <?= $_->{module} ?>::Config;

our $models = { };
sub model {
	my ($name) = @_;
	my $class = __PACKAGE__ . "::Model::$name";
	$models->{$name} ||= do {
		$class->require or die $@;
		my $conf = lc $name;
		my $opts = config->param("model_$conf");
		$class->new(@$opts)
	};
}

1;
__END__



