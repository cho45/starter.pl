package <?= $_->{module} ?>::Browser;

use strict;
use warnings;

sub new {
	my ($class, $user_agent) = @_;
	my $self = bless { user_agent => $user_agent }, $class;

	local $_ = $user_agent;
	/iPhone/       and $self->{is_iphone}  = 1;
	/iPod/         and $self->{is_iphone}  = 1;
	/iPad/         and $self->{is_ipad}    = 1;
	/Android/      and $self->{is_android} = 1;
	/Nintendo DSi/ and $self->{is_dsi} = 1;
	/Nintendo Wii/ and $self->{is_wii} = 1;

	$self;
}

sub is_iphone  { $_[0]->{is_iphone} }
sub is_ipad    { $_[0]->{is_ipad} }
sub is_android { $_[0]->{is_android} }
sub is_dsi     { $_[0]->{is_dsi} }
sub is_wii     { $_[0]->{is_wii} }

sub is_pc {
	!$_[0]->{is_iphone} &&
	!$_[0]->{is_ipad}   &&
	!$_[0]->{is_dsi}    &&
	!$_[0]->{is_wii}    &&
	!$_[0]->{is_android}
}

sub is_mobile {
	0
}


1;
