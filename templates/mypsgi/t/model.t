use strict;
use warnings;

use UNIVERSAL::require;
use Test::Most;
use Encode;

use lib glob 'modules/*/lib';

sub u8 ($) { decode_utf8(shift) };
sub is_utf8 ($;$) { ok utf8::is_utf8(shift), shift };

ok 1;

done_testing;
