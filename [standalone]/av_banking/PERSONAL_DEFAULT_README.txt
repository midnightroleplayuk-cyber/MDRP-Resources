FIX: First-time personal accounts showing Checking

The protected server may explicitly insert Checking, which bypasses the SQL column default.
Run APPLY_PERSONAL_DEFAULT.sql in your live MySQL/MariaDB database (e.g. via phpMyAdmin/HeidiSQL). This replaces the old trigger.

New personal accounts labelled Checking or blank on INSERT become Personal. Custom labels are preserved. Existing rows are NOT renamed.

If the UI still shows Checking after creating a genuinely new account, the protected server may return a hard-coded label without reading the stored value. Check the database label for that account.
