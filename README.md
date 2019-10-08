# Analyzer Orchestrator

An Orchestrator for Exercism's code Analyzers

## Local setup

```bash
mysql -e "CREATE USER 'exercism_representations'@'localhost' IDENTIFIED BY 'exercism_representations'" -u root -p
mysql -e "create database exercism_representations_development" -u root -p
mysql -e "create database exercism_representations_test" -u root -p
mysql -e "ALTER DATABASE exercism_representations_development CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" -u root -p
mysql -e "ALTER DATABASE exercism_representations_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON exercism_representations_development.* TO 'exercism_representations'@'localhost'" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON exercism_representations_test.* TO 'exercism_representations'@'localhost'" -u root -p

mysql -e "DROP TABLE IF EXISTS exercism_representations_development.fixtures; CREATE TABLE exercism_representations_development.fixtures (track_slug VARCHAR(50), exercise_slug VARCHAR(100), representation TEXT, status VARCHAR(25), comments_data TEXT);" -u root -p
mysql -e "DROP TABLE IF EXISTS exercism_representations_test.fixtures; CREATE TABLE exercism_representations_test.fixtures (track_slug VARCHAR(50), exercise_slug VARCHAR(100), representation TEXT, status VARCHAR(25), comments_data TEXT);" -u root -p
```



## Copyright

All content in this repository is Copyright to Exercism and licenced under MIT.
