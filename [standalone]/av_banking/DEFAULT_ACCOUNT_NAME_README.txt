Default personal account label: Bank Account - Personal

New native personal accounts are assigned this label via the SQL trigger in database.sql. Existing player names are not changed. Player renaming remains available.

IMPORTANT: On an existing server, run the DROP TRIGGER / CREATE TRIGGER statements at the end of database.sql in your database client. Simply replacing the resource files does not install the trigger.

The bundled browser preview also uses the new label. The protected server resource was not modified.
