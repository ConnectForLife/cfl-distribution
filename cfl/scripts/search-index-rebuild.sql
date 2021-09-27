-- Cause rebuilding of a search index
DELETE FROM global_property WHERE property = 'search.indexVersion';
