CREATE TABLE entry (
	`id` INTEGER PRIMARY KEY,
	`editting` BOOL NOT NULL DEFAULT 0,
	`title` TEXT NOT NULL,
	`content` TEXT NOT NULL,
	`created_at` DATETIME NOT NULL,
	`modified_at` DATETIME NOT NULL
);
CREATE INDEX index_created_at ON entry (`created_at`);

