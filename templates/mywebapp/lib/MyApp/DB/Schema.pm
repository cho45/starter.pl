package MyApp::DB::Schema;

use utf8;
use strict;
use warnings;

use Teng::Schema::Declare;

table {
	name "entry";
	pk "id";
	columns qw(
		id
		title
		content
		updated_at
		created_at
	);
};

1;
