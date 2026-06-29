import pandas as pd
df = pd.read_csv("openpowerlifting-2024-03-02/openpowerlifting-2024-03-02-5a1ba3a1.csv")
athletes = df[["Name","Sex"]].drop_duplicates()
athletes.to_csv("data/athletes.csv", index=False)

federations = df[["Federation","ParentFederation"]].drop_duplicates()
federations.to_csv("data/federations.csv", index=False)

meets = df[["Federation",
             "Date",
             "MeetCountry",
             "MeetState",
             "MeetTown",
             "MeetName",
             "Country",
             "State",
             "Tested"]].drop_duplicates(subset=["Date","MeetName","Federation"])
meets.to_csv("data/meets.csv", index=False)

meet_performances = df[["Name",
                        "Sex",
                        "Federation",
                        "AgeClass",
                        "BirthYearClass",
                        "Division",
                        "Equipment",
                        "BodyweightKg",
                        "WeightClassKg",
                        "Squat1Kg",
                        "Squat2Kg",
                        "Squat3Kg",
                        "Squat4Kg",
                        "Bench1Kg",
                        "Bench2Kg",
                        "Bench3Kg",
                        "Bench4Kg",
                        "Deadlift1Kg",
                        "Deadlift2Kg",
                        "Deadlift3Kg",
                        "Deadlift4Kg",
                        "Best3SquatKg",
                        "Best3BenchKg",
                        "Best3DeadliftKg",
                        "TotalKg",
                        "Place",
                        "Dots",
                        "Wilks",
                        "Glossbrenner",
                        "Goodlift",
                        "Date"]] 
meet_performances.to_csv("data/meet_performances.csv",index=False)
