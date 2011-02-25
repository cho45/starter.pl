package <?= $_->{module} ?>::Model::Entry::Schema;
use strict;
use warnings;

use Teng::Schema::Declare;
use JSON::XS;

table {
	name 'entry';
	pk 'id';
	columns qw(
		id
		user_id
		content
		struct
		created
	);

	inflate struct => sub {
		decode_json(shift);
	};

	deflate struct => sub {
		encode_json(shift);
	};

	inflate created => sub {
		parse_datetime(shift)->set_time_zone('UTC');
	};

	deflate created => sub {
		format_datetime(shift->set_time_zone('UTC'));
	};
};

1;
