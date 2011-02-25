package <?= $_->{module} ?>::Model::Util;

use strict;
use warnings;
use parent qw(Exporter::Lite);
use DateTime::Format::MySQL;
use Encode::Base58::BigInt;

our @EXPORT = qw(
    encode_uuid
    decode_uuid
    format_datetime
    parse_datetime
    time_zone
);


my $DATABASE_TIME_ZONE = "Asia/Tokyo";

sub time_zone () {
    $DATABASE_TIME_ZONE;
}

sub encode_uuid {
    encode_base58(shift);
}

sub decode_uuid {
    decode_base58(shift);
}

sub format_datetime {
    DateTime::Format::MySQL->format_datetime(shift),
}

sub parse_datetime {
    DateTime::Format::MySQL->parse_datetime(shift),
}

1;
__END__



