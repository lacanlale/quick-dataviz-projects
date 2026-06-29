CREATE TYPE valid_sex AS ENUM('M', 'F');
CREATE TABLE IF NOT EXISTS Athletes(
	athlete_id BIGSERIAL NOT NULL PRIMARY KEY,
	athlete_name VARCHAR(80) NOT NULL,
	sex valid_sex
);

CREATE TABLE IF NOT EXISTS Federations(
	federation_id BIGSERIAL NOT NULL PRIMARY KEY,
	federation VARCHAR(50) NOT NULL,
	parent_federation VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Meets(
	meet_id BIGSERIAL NOT NULL PRIMARY KEY,
	federation_id INT REFERENCES Federations(federation_id),
	meet_date DATE NOT NULL,
	country VARCHAR(50),
	"state" VARCHAR(50),
	meet_country VARCHAR(50),
	meet_state VARCHAR(50),
    meet_town VARCHAR(55),
	tested BOOL,
    name VARCHAR(255)
);

CREATE TYPE valid_equipment AS ENUM('Raw', 'Wraps', 'Multi-ply', 'Single-ply', 'Unlimited', 'Straps');
CREATE TABLE IF NOT EXISTS Athlete_Meet_Performances(
	athlete_id BIGINT NOT NULL REFERENCES Athletes(athlete_id),
	federation_id BIGINT NOT NULL REFERENCES Federations(federation_id),
	meet_id BIGINT NOT NULL REFERENCES Meets(meet_id),
	age_class VARCHAR(10),
	birth_year_class VARCHAR(10),
	division VARCHAR(50),
	equipment valid_equipment,
	bodyweight_kg FLOAT,
	weight_class_kg VARCHAR(10),
	squat1_kg FLOAT,
	squat2_kg FLOAT,
	squat3_kg FLOAT,
	squat4_kg FLOAT,
	bench1_kg FLOAT,
	bench2_kg FLOAT,
	bench3_kg FLOAT,
	bench4_kg FLOAT,
	deadlift1_kg FLOAT,
	deadlift2_kg FLOAT,
	deadlift3_kg FLOAT,
	deadlift4_kg FLOAT,
	best_3_squat_kg FLOAT,
	best_3_bench_kg FLOAT,
	best_3_deadlift_kg FLOAT,
	goodlift Float,
	total_kg FLOAT,
	place VARCHAR(5),
	dots FLOAT,
	wilks FLOAT,
	glossbrenner FLOAT
);
