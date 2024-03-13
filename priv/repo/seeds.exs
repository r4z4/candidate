# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FanCan.Repo.insert!(%FanCan.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# 8d04fd4f-1321-4e9f-911a-7369d57d0b55

alias FanCan.Repo
alias FanCan.Accounts.{User, UserHolds, Authorize}
alias FanCan.Public.{Candidate, Election, State, Legislator}
alias FanCan.Site.Forum
alias FanCan.Public.Election.Ballot
alias FanCan.Site.Forum.Post
alias FanCan.Site.Forum.Thread
alias FanCan.Core.{Attachment, Hold}
alias FanCan.Public.Election.{Race, Ballot, RaceHolds, ElectionHolds, CandidateHolds}

Repo.insert_all(State, [
      %{id: 1, name: :Alabama, code: :AL, num_districts: 7, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 2, name: :Alaska, code: :AK, num_districts: 0, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 3, name: :Arizona, code: :AZ, num_districts: 9, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 4, name: :Arkansas, code: :AR, num_districts: 4, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 5, name: :California, code: :CA, num_districts: 52, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 6, name: :Colorado, code: :CO, num_districts: 8, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 7, name: :Connecticut, code: :CT, num_districts: 5, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 8, name: :Delaware, code: :DE, num_districts: 1, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 9, name: :Florida, code: :FL, num_districts: 28, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 10, name: :Georgia, code: :GA, num_districts: 14, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 11, name: :Hawaii, code: :HI, num_districts: 2, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 12, name: :Idaho, code: :ID, num_districts: 2, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 13, name: :Illinois, code: :IL, num_districts: 17, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 14, name: :Indiana, code: :IN, num_districts: 9, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 15, name: :Iowa, code: :IA, num_districts: 4, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 16, name: :Kansas, code: :KS, num_districts: 4, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 17, name: :Kentucky, code: :KY, num_districts: 6, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 18, name: :Louisiana, code: :LA, num_districts: 6, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 19, name: :Maine, code: :ME, num_districts: 2, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 20, name: :Maryland, code: :MD, num_districts: 8, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 21, name: :Massachusetts, code: :MA, num_districts: 9, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 22, name: :Michigan, code: :MI, num_districts: 13, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 23, name: :Minnesota, code: :MN, num_districts: 8, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 24, name: :Mississippi, code: :MS, num_districts: 4, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 25, name: :Missouri, code: :MO, num_districts: 8, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 26, name: :Montana, code: :MT, num_districts: 2, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 27, name: :Nebraska, code: :NE, num_districts: 3, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 28, name: :Nevada, code: :NV, num_districts: 4, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 29, name: :New_Hampshire, code: :NH, num_districts: 4, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 30, name: :New_Jersey, code: :NJ, num_districts: 12, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 31, name: :New_Mexico, code: :NM, num_districts: 3, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 32, name: :New_York, code: :NY, num_districts: 26, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 33, name: :North_Carolina, code: :NC, num_districts: 14, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 34, name: :North_Dakota, code: :ND, num_districts: 3, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 35, name: :Ohio, code: :OH, num_districts: 15, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 36, name: :Oklahoma, code: :OK, num_districts: 5, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 37, name: :Oregon, code: :OR, num_districts: 6, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 38, name: :Pennsylvania, code: :PA, num_districts: 17, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 39, name: :Rhode_Island, code: :RI, num_districts: 2, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 40, name: :South_Carolina, code: :SC, num_districts: 7, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 41, name: :South_Dakota, code: :SD, num_districts: 1, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 42, name: :Tennessee, code: :TN, num_districts: 9, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 43, name: :Texas, code: :TX, num_districts: 38, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 44, name: :Utah, code: :UT, num_districts: 4, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 45, name: :Vermont, code: :VT, num_districts: 4, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 46, name: :Virginia, code: :VA, num_districts: 11, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 47, name: :Washington, code: :WA, num_districts: 10, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 48, name: :West_Virginia, code: :WV, num_districts: 2, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 49, name: :Wisconsin, code: :WI, num_districts: 8, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: 50, name: :Wyoming, code: :WY, num_districts: 1, governor: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()}
])

Repo.insert_all(User, [
      %{id: "a9f44567-e031-44f1-aae6-972d7aabbb45", username: "admin", city: "Rapid City", state: :SD, district: nil, email: "admin@admin.com", role: :admin, hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "b5f44567-e031-44f1-aae6-972d7aabbb45", username: "jim_the_og", city: "Omaha", state: :NE, district: nil, email: "jim@jim.com", role: :voter, hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", username: "aaron", city: "Lincoln", state: :NE, district: nil, email: "aaron@aaron.com", role: :voter, hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", username: "mn_voter", city: "Minneapolis", state: :MN, district: nil, email: "mn_voter@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "459180af-49aa-48df-92e2-547be9283ac4", username: "wi_voter", city: "Waupaca", state: :WI, district: nil, email: "wi_voter@example.com", role: :candidate, hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "cf1ffc43-58a2-40e2-b08a-86bb2089ba64", username: "ia_voter", city: "Ames", state: :IA, district: nil, email: "ia_voter@example.com", role: :candidate, hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "4a501cb1-6e1c-45c1-8397-9bbd4a312044", username: "ca_voter", city: "Sacramento", state: :CA, district: nil, email: "ca_voter@example.com", role: :candidate, hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "549a7ba0-ea59-4333-bd01-eb4b3e4420f8", username: "il_voter", city: "Chicago", state: :IL, district: nil, email: "il_voter@example.com", role: :candidate, hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "b2f44567-e031-44f1-aae6-972d7aabbb45", username: "tx_voter", city: "Austin", state: :TX, district: nil, email: "tx_voter@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()}
])

Repo.insert_all(Attachment, [
      %{id: "a7f44567-e031-44f1-aae6-972d7aabbb45", type: :image, title: "Test Democrat", path: "https://upload.wikimedia.org/wikipedia/commons/b/bb/PavelTravnicek2022.jpg", data: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "a5f44567-e031-44f1-aae6-972d7aabbb45", type: :image, title: "Test Republican", path: "https://upload.wikimedia.org/wikipedia/commons/c/c4/Roy_Dale_Cope.jpg", data: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "a8f14567-e031-44f1-aae6-972d7aabbb45", type: :image, title: "NE_Rep_2022", path: "https://upload.wikimedia.org/wikipedia/commons/9/94/Adrian_Smith_116th_Congress.jpg", data: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "a6f14567-e031-44f1-aae6-972d7aabbb45", type: :image, title: "NE_Rep_2022", path: "https://upload.wikimedia.org/wikipedia/commons/b/bc/Mike_Flood_117th_Congress_%28cropped%29.jpeg", data: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "a2f14567-e031-44f1-aae6-972d7aabbb45", type: :image, title: "NE_Rep_2022", path: "https://upload.wikimedia.org/wikipedia/commons/5/5f/Don_Bacon_portrait_%28118th_Congress%29.jpg", data: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "a5f44967-e031-44f1-aae6-972d7aabbb45", type: :image, title: "NE_Gov_2018", path: "https://upload.wikimedia.org/wikipedia/commons/b/bd/Sen._Pete_Ricketts_official_portrait%2C_118th_Congress.jpg", data: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "a5f88967-e031-44f1-aae6-972d7aabbb45", type: :image, title: "NE_Gov_2022", path: "https://upload.wikimedia.org/wikipedia/commons/7/72/Jim_Pillen_%28cropped%29.jpg", data: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "a5f44567-e031-44f1-aae6-972d7aabbb49", type: :image, title: "AK_Gov", path: "https://en.wikipedia.org/wiki/Mike_Dunleavy_(politician)#/media/File:Mike_Dunleavy_official_photo.jpg", data: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "a1f44367-e031-44f1-aae6-972d7aabbb49", type: :image, title: "JulieSlama", path: "https://upload.wikimedia.org/wikipedia/commons/2/21/Julie_Slama_%2851850518231%29.jpg", data: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "848dd11c-d924-48e7-bdc2-9db000222365", type: :image, title: "DebF", path: "https://upload.wikimedia.org/wikipedia/commons/9/93/Deb_Fischer_official_Senate_photo.jpg", data: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()}
])
# # Removing IDs but will need them for prod likely (binary_id vs. int)
Repo.insert_all(Candidate, [
      %{id: "0e31998f-503f-4218-a801-c8bb7ff9498b", prefix: :Mr, f_name: "Robert", l_name: "Boyd", suffix: :Jr, incumbent_since: nil, dob: ~D[1976-05-05], district: 10, attachments: ["a7f44567-e031-44f1-aae6-972d7aabbb45"],
      party: :Democrat, cpvi: "D+20", education: ["University of Nebraska-Lincoln"], birth_state: :NE, state: :NE, seat: :Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "0e91998f-503f-4218-a801-c8bb7ff9498b", prefix: nil, f_name: "Joe", l_name: "Trumpet", suffix: :III, incumbent_since: ~D[2020-11-04], dob: ~D[1980-09-01], district: 10, attachments: ["a5f44567-e031-44f1-aae6-972d7aabbb45"],
      party: :Republican, cpvi: "R+10", education: ["University of Nebraska-Omaha"], birth_state: :NE, state: :NE, seat: :Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "0e91798f-503f-4218-a801-c8bb7ff9498b", prefix: :Dr, f_name: "Judson", l_name: "Frazier", suffix: nil, incumbent_since: ~D[2016-11-04], dob: ~D[1980-09-01], district: 3, attachments: nil,
      party: :Republican, cpvi: "R+30", education: ["University of Nebraska-Lincoln"], birth_state: :NE, state: :NE, seat: :Judge, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "0e91198f-503f-4218-a801-c8bb7ff9498b", prefix: nil, f_name: "Pete", l_name: "Ricketts", suffix: nil, incumbent_since: nil, dob: ~D[1964-08-19], district: nil, attachments: ["a5f44967-e031-44f1-aae6-972d7aabbb45"],
      party: :Republican, cpvi: "R+30", education: ["University of Chicago"], birth_state: :NE, state: :NE, seat: :Governor, end_date: ~D[2023-01-05], inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      # NE Gov Race E.g.
      %{id: "0e97798f-503f-4218-a801-c8bb7ff9498b", prefix: nil, f_name: "Jim", l_name: "Pillen", suffix: nil, incumbent_since: ~D[2023-01-05], dob: ~D[1955-12-31], district: nil, attachments: ["a5f88967-e031-44f1-aae6-972d7aabbb45"],
      party: :Republican, cpvi: "R+30", education: ["University of Nebraska Lincoln", "Kansas State University"], birth_state: :NE, state: :NE, seat: :Governor, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "4ed97c3a-15ff-45a7-af6c-6e37bcdb943b", prefix: nil, f_name: "Carol", l_name: "Blood", suffix: nil, incumbent_since: ~D[2017-01-04], dob: ~D[1961-03-05], district: 3, attachments: nil,
      party: :Democrat, cpvi: "D+20", education: ["Metropolitan Community College"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},

#       # NE House Reps
      %{id: "0e97798f-503f-4218-a801-c8bb1ff9498b", prefix: nil, f_name: "Mike", l_name: "Flood", suffix: nil, incumbent_since: ~D[2022-07-12], dob: ~D[1975-02-23], district: 1, attachments: ["a6f14567-e031-44f1-aae6-972d7aabbb45"],
      party: :Republican, cpvi: "R+9", education: ["University of Notre Dame", "University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :Representative, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "0e97798f-503f-4218-a801-c8bb2ff9498b", prefix: nil, f_name: "Don", l_name: "Bacon", suffix: nil, incumbent_since: ~D[2017-01-03], dob: ~D[1963-08-16], district: 2, attachments: ["a2f14567-e031-44f1-aae6-972d7aabbb45"],
      party: :Republican, cpvi: "EVEN", education: ["Northern Illinois University", "University of Phoenix", "National War College"], birth_state: :IL, state: :NE, seat: :Representative, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "0e97798f-503f-4218-a801-c8bb3ff9498b", prefix: nil, f_name: "Adrian", l_name: "Smith", suffix: nil, incumbent_since: ~D[2007-01-04], dob: ~D[1970-12-19], district: 3, attachments: ["a8f14567-e031-44f1-aae6-972d7aabbb45"],
      party: :Republican, cpvi: "R+29", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :Representative, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},

      %{id: "0e91138f-503f-4218-a801-c8bb7ff3398b", prefix: nil, f_name: "Pete", l_name: "Ricketts", suffix: nil, incumbent_since: ~D[2023-01-23], dob: ~D[1964-08-19], district: nil, attachments: ["a5f44967-e031-44f1-aae6-972d7aabbb45"],
      party: :Republican, cpvi: "R+30", education: ["University of Chicago"], birth_state: :NE, state: :NE, seat: :Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "0e91778f-503f-4218-a801-c8bb7ff9498b", prefix: nil, f_name: "Mike", l_name: "Dunleavy", suffix: nil, incumbent_since: ~D[2018-12-03], dob: ~D[1961-05-06], district: nil, attachments: ["a5f44567-e031-44f1-aae6-972d7aabbb49"],
      party: :Republican, cpvi: "R+30", education: ["Misericordia University", "University of Alaska Fairbanks"], birth_state: :PA, state: :AK, seat: :Governor, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},

#       # Senators
      %{id: "9b9b951e-3f3c-4350-8ffb-a36a981e376d", prefix: nil, suffix: nil, incumbent_since: ~D[2012-01-05], dob: ~D[1951-03-01], attachments: ["848dd11c-d924-48e7-bdc2-9db000222365"], district: nil, l_name: "Fischer", f_name: "Deb",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "55f7e3e6-883a-4c4a-b04c-b69bcc741273", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: nil, l_name: "Shelton", f_name: "Alicia",
      party: :Democrat, cpvi: "D+13", education: ["Xavier University", "Bellevus University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
#       # NE State Senate Contenders
      %{id: "049acd0a-427b-4096-8cd5-1ce59845649e", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 2, l_name: "Slattery", f_name: "Sarah",
      party: :Democrat, cpvi: "EVEN", education: [], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "13bf326e-8d5b-4ddf-9de7-49508481a57b", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 4, l_name: "Maxwell-Ostdiek", f_name: "Cindy",
      party: :Independent, cpvi: "EVEN", education: [], birth_state: :IA, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "09f131ac-818c-4058-b9ce-dc3b91794416", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 6, l_name: "Mirch", f_name: "Christian",
      party: :Republican, cpvi: "EVEN", education: ["Creighton University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "0423af0e-4b1e-43d4-9a47-559ce17cdd4f", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 10, l_name: "Goding", f_name: "Lou Ann",
      party: :Non_Partisan, cpvi: "EVEN", education: ["Bob Jones University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},

#       # Making 'em up Now
      %{id: "93f33178-116a-48eb-9033-e599e2525994", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 8, l_name: "Junipa", f_name: "Jane",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "cbb9d25d-1f2b-4a84-9968-28b97f90e798", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 12, l_name: "Slattery", f_name: "Sarah",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "fb85d774-5e3d-4d43-9bfc-a2dfba5b1ab0", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 14, l_name: "Maxwell", f_name: "Ron",
      party: :Independent, cpvi: "EVEN", education: [], birth_state: :IA, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "9e391259-4f6c-4750-9890-ff4fad514747", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 16, l_name: "Smith", f_name: "Lexie",
      party: :Republican, cpvi: "EVEN", education: ["Creighton University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "6668b0e6-b43b-45e5-bc61-b946d3b4a942", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 18, l_name: "Rhodes", f_name: "Lou",
      party: :Non_Partisan, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "b7403749-efd0-4c72-b3e4-15097f4475ba", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 20, l_name: "Loops", f_name: "Sue",
      party: :Democrat, cpvi: "EVEN", education: [], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "d92a4602-25e3-4aed-9bf2-241cdc0fa361", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 22, l_name: "Hawkins", f_name: "Patty",
      party: :Independent, cpvi: "EVEN", education: [], birth_state: :IA, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "0f71a982-1d18-466b-95da-2d1117a0db66", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 24, l_name: "Burns", f_name: "Steve",
      party: :Independent, cpvi: "D+15", education: [], birth_state: :IA, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "41b2b493-3a0b-46d5-9287-6d1ee2637fcc", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 26, l_name: "Ryan", f_name: "Mike",
      party: :Republican, cpvi: "R+15", education: ["Creighton University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "cdd6bf85-e96c-45ea-86aa-fc232cbdd659", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 28, l_name: "Melvin", f_name: "Alexander",
      party: :Democrat, cpvi: "D+15", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "2cf2b454-c9f2-47a4-a46d-89317a1d6638", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 30, l_name: "Gil", f_name: "Billy",
      party: :Non_Partisan, cpvi: "D+15", education: ["University of Nebraska Kearney"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "f7724ba1-a70d-492c-9310-a54a8de40930", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 32, l_name: "Cote", f_name: "Greg",
      party: :Democrat, cpvi: "D+15", education: [], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "71b69043-021b-482d-a171-ea0bfe124b0f", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 34, l_name: "Cote", f_name: "Chris",
      party: :Independent, cpvi: "D+15", education: [], birth_state: :IA, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "10682205-5ea0-4270-9a93-0b77d03aeec3", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 36, l_name: "Mirch", f_name: "Christian",
      party: :Democrat, cpvi: "D+22", education: ["Creighton University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "9b901b07-ac46-4e60-825f-32a99af907bd", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 38, l_name: "Stevens", f_name: "Jackson",
      party: :Independent, cpvi: "EVEN", education: [], birth_state: :IA, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "cba473d7-0162-4da8-ad05-ff3c15275923", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 40, l_name: "Kyle", f_name: "Ann",
      party: :Non_Partisan, cpvi: "EVEN", education: ["University of Nebraska Omaha"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "04dfecbe-290e-4806-8d33-0772cde2686b", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 42, l_name: "Howl", f_name: "Christian",
      party: :Republican, cpvi: "EVEN", education: ["Creighton University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "810ca1e4-1ffe-4f53-92b7-8664c5692eca", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 44, l_name: "Kents", f_name: "Ann",
      party: :Non_Partisan, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "8ef1ba51-a889-4d63-8bca-d1f3de543d52", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 46, l_name: "Refins", f_name: "Sarah",
      party: :Democrat, cpvi: "EVEN", education: [], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "4c103841-db5e-4dce-8451-6b7a0cb60e15", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 48, l_name: "Blouse-Osk", f_name: "Bert",
      party: :Independent, cpvi: "EVEN", education: [], birth_state: :IA, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},


      # %{id: "02a35ff9-e7a0-4250-ba24-c04c7eba2eaf", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 26, l_name: "Mirch", f_name: "Christian",
      # party: :Republican, cpvi: "EVEN", education: ["Creighton University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      # %{id: "7cda5cc4-62be-44b6-962b-9a4c7e18ac99", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 30, l_name: "Goding", f_name: "Lou Ann",
      # party: :Non_Partisan, cpvi: "EVEN", education: ["Bob Jones University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      # %{id: "407d9c72-c291-46a7-b5c7-afa75074534d", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 32, l_name: "Slattery", f_name: "Sarah",
      # party: :Democrat, cpvi: "EVEN", education: [], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      # %{id: "35f93076-2ecd-4e6f-9c10-4e77ea3c2358", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 34, l_name: "Maxwell-Ostdiek", f_name: "Cindy",
      # party: :Independent, cpvi: "EVEN", education: [], birth_state: :IA, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      # %{id: "ef8d6989-5245-40dc-8e66-26f2bf786e27", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 36, l_name: "Mirch", f_name: "Christian",
      # party: :Republican, cpvi: "EVEN", education: ["Creighton University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      # %{id: "06490f44-d830-4ff7-b18e-53bd6b1526f9", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 40, l_name: "Goding", f_name: "Lou Ann",
      # party: :Non_Partisan, cpvi: "EVEN", education: ["Bob Jones University"], birth_state: :NE, state: :NE, seat: nil, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},

#       # NE State Senators
      %{id: "0e33778f-503f-4218-a801-c8bb7ff9498b", prefix: nil, suffix: nil, incumbent_since: ~D[2019-01-09], dob: ~D[1996-05-02], attachments: ["a1f44367-e031-44f1-aae6-972d7aabbb49"], district: 1, l_name: "Slama", f_name: "Julie",
      party: :Republican, cpvi: "EVEN", education: ["Yale University"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "7460e15c-64ab-42d1-b536-8116e82acfbe", prefix: nil, suffix: nil, incumbent_since: ~D[2017-01-04], dob: nil, attachments: nil, district: 2, l_name: "Clements", f_name: "Robert",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: ~D[2027-01-01], inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      # %{id: Ecto.UUID.generate(), prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 3, l_name: "Blood", f_name: "Carol",
      # party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "f56539b0-e259-498a-afd3-c2c4da769772", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 4, l_name: "von Gillern", f_name: "Brad",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: Ecto.UUID.generate(), prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 5, l_name: "McDonnell", f_name: "Mike",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "5ab8d863-9eca-4ff3-a654-9dfcdab59f7c", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 6, l_name: "Cavanaugh", f_name: "Machaela",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: Ecto.UUID.generate(), prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 7, l_name: "Vargas", f_name: "Tony",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "7e8750c4-2872-4dad-a793-7a6915d8ef75", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 8, l_name: "Hunt", f_name: "Megan",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: Ecto.UUID.generate(), prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 9, l_name: "Cavanaugh", f_name: "John",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "5ab8d863-9eca-4ff3-a654-9dfcdab99f7c", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 10, l_name: "DeBoer", f_name: "Wendy",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "fb298b8b-0b87-45e4-bc85-fa6caaa2996e", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 11, l_name: "McKinney", f_name: "Terrell",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "79db9a33-e625-45cc-882d-c8da27a1c756", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 12, l_name: "Riepe", f_name: "Merv",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "3b196927-9331-4e9d-a82e-3c42b2a563e2", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 13, l_name: "Wayne", f_name: "Justin",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "adea9986-0c90-4196-9512-def9eb0e68e7", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 14, l_name: "Arch", f_name: "John",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "e470ca03-2c1a-4b6a-9635-c51302c7b404", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 15, l_name: "Walz", f_name: "Lynne",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "43838b15-1de6-4a08-af0f-995b58dbf142", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 16, l_name: "Hansen", f_name: "Ben",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "3eb07fd5-311c-4fa1-af90-0acabe2a8d2a", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 17, l_name: "Albrecht", f_name: "Joni",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "53982e76-2d51-4b2d-aa14-8954ff3edc22", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 18, l_name: "Armendariz", f_name: "Christy",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "65827eeb-7704-4e9c-9e40-d95d8e95ba5e", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 19, l_name: "Dover", f_name: "Robert",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "25881722-e178-47ef-b916-c3574f7fb063", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 20, l_name: "Fredrickson", f_name: "John",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "fcfdb9d7-eabe-4b44-a650-596dfc540d0a", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 21, l_name: "Ballard", f_name: "Beau",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "0ce64757-3bf2-4779-99ca-3b5b35d59c4d", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 22, l_name: "Moser", f_name: "Mike",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "05416b9c-6d14-42d1-aa7f-4a189a6d876a", prefix: nil, suffix: nil, incumbent_since: ~D[2017-01-04], dob: nil, attachments: nil, district: 23, l_name: "Bostelman", f_name: "Bruce",
      party: :Republican, cpvi: "EVEN", education: ["Bellevue University"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "920f6424-0ca3-4a08-bbd7-b4d4bd0e28d8", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 24, l_name: "Hughes", f_name: "Jana",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "895f54ba-3ca6-45f8-9a40-52d64af5cc3a", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 25, l_name: "Bosn", f_name: "Carolyn",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "10b1ff89-2bbb-4b6e-a77a-ca96e822c7b2", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 26, l_name: "Dungan", f_name: "George",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "a97cd5fa-021a-4f55-b97e-133fcf81330a", prefix: nil, suffix: nil, incumbent_since: ~D[2017-01-04], dob: ~D[1985-01-02], attachments: nil, district:  27, l_name: "Wishart", f_name: "Anna",
      party: :Democrat, cpvi: "EVEN", education: ["Middlebury College"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "6f4a6011-e289-453c-ac12-06d25911c83f", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 28, l_name: "Raybould", f_name: "Jane",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Kearney"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "2d66350a-d097-41d4-8d0d-d836c751dcdd", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 29, l_name: "Bostar", f_name: "Eliot",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "9146213f-4046-41f5-bb56-b099ee0b9779", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 30, l_name: "Dorn", f_name: "Myron",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Kearney"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "03077f2c-0da8-4fa3-885c-67ad0c1b4f6b", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 31, l_name: "Kauth", f_name: "Kathleen",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "cbfb86db-ec52-479e-a30c-5bd6ffe22979", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 32, l_name: "Brandt", f_name: "Tom",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "6eab1b9b-bb7a-4c8b-b3d8-53a463ab0355", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 33, l_name: "Halloran", f_name: "Steve",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "9f73ece1-cb23-49e9-b190-83b652e5301d", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 34, l_name: "Lippincott", f_name: "Loren",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "33ecf28b-7faf-4d22-a635-6752df51ac15", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 35, l_name: "Aguilar", f_name: "Raymond",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Kearney"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "33198d60-fa84-409f-8b0b-f335d689df0e", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 36, l_name: "Holdcroft", f_name: "Rick",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Omaha"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "e4a00958-728c-4666-b21a-a497ee0114bc", prefix: nil, suffix: :Sr, incumbent_since: nil, dob: nil, attachments: nil, district: 37, l_name: "Lowe", f_name: "John",
      party: :Republican, cpvi: "EVEN", education: ["University of Kansas"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "cea32d7e-8e1f-4c20-9e27-41d7a4d2d728", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 38, l_name: "Murman", f_name: "Dave",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Omaha"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "ff08ea07-c821-4a55-9896-0c51b35354f8", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 39, l_name: "Linehan", f_name: "Lou Ann",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "4169f369-f1d2-40a9-9d62-8db88e824e59", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 40, l_name: "DeKay", f_name: "Barry",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "1baa0493-4074-4f2c-8d4a-dd7d2acd91d1", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 41, l_name: "Briese", f_name: "Tom",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "f3b82e41-e202-4190-85c6-ceb2b73d1791", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 42, l_name: "Jacobson", f_name: "Mike",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Kearney"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "b4ec5521-7cc4-459e-b1c7-ba5c4d6c4380", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 43, l_name: "Brewer", f_name: "Tom",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "85291a9d-10d4-4fea-9cab-5ac6d79f2de1", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 44, l_name: "Ibach", f_name: "Teresa",
      party: :Republican, cpvi: "EVEN", education: ["University of Notre Dame"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "e049f1db-8959-4132-85b8-60af34da1788", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 45, l_name: "Sanders", f_name: "Rita",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "197a9621-bcaf-4ec7-82c1-ff3983d89032", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 46, l_name: "Conrad", f_name: "Danielle",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Kearney"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "dd0ec4e8-d0fb-4e42-99c0-c84388b7f3d1", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 47, l_name: "Erdman", f_name: "Steve",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "16657cef-5e9e-48af-8734-254ee77e3db7", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 48, l_name: "Hardin", f_name: "Brian",
      party: :Republican, cpvi: "EVEN", education: ["University of Nebraska Kearney"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{id: "b7f2c6b9-3460-4b3f-8430-e66f9ce272ee", prefix: nil, suffix: nil, incumbent_since: nil, dob: nil, attachments: nil, district: 49, l_name: "Day", f_name: "Jen",
      party: :Democrat, cpvi: "EVEN", education: ["University of Nebraska Lincoln"], birth_state: :NE, state: :NE, seat: :State_Senator, end_date: nil, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()}

])

Repo.insert_all(Election, [
      %{id: "a1f44567-e031-44f1-aae6-972d7aabbb45", desc: "2022 Midterms", election_date: ~D[2021-11-01], state: :NE, year: 2022, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "bfe75d28-b2eb-4478-82f5-17828f9c82c6", desc: "2024 General", election_date: ~D[2023-11-01], state: :NE, year: 2024, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "b566874e-dee8-4d31-a67e-a0ec5c9254b1", desc: "2024 Midterms", election_date: ~D[2024-11-04], state: :NE, year: 2024, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "2fbd4c9f-ce09-406d-9548-69478f0dab69", desc: "2024 Midterms", election_date: ~D[2024-11-04], state: :MN, year: 2024, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()}
])

# # Elect % 0.0 for non-race (appointments, emergency positions etc...). Add a notes col or table
Repo.insert_all(Race, [
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "5ab8d863-9eca-4ff3-a654-9dfcdab59f7c", district: "6", candidates: ["5ab8d863-9eca-4ff3-a654-9dfcdab59f7c", "09f131ac-818c-4058-b9ce-dc3b91794416"], candidate_one: "5ab8d863-9eca-4ff3-a654-9dfcdab59f7c", candidate_two: "09f131ac-818c-4058-b9ce-dc3b91794416", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 53.3, elect: "f56539b0-e259-498a-afd3-c2c4da769772", district: "4", candidates: ["f56539b0-e259-498a-afd3-c2c4da769772", "13bf326e-8d5b-4ddf-9de7-49508481a57b"], candidate_one: "f56539b0-e259-498a-afd3-c2c4da769772", candidate_two: "13bf326e-8d5b-4ddf-9de7-49508481a57b", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 57.2, elect: "7460e15c-64ab-42d1-b536-8116e82acfbe", district: "2", candidates: ["7460e15c-64ab-42d1-b536-8116e82acfbe", "049acd0a-427b-4096-8cd5-1ce59845649e"], candidate_one: "7460e15c-64ab-42d1-b536-8116e82acfbe", candidate_two: "049acd0a-427b-4096-8cd5-1ce59845649e", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "5ab8d863-9eca-4ff3-a654-9dfcdab99f7c", district: "10", candidates: ["5ab8d863-9eca-4ff3-a654-9dfcdab99f7c", "0423af0e-4b1e-43d4-9a47-559ce17cdd4f"], candidate_one: "5ab8d863-9eca-4ff3-a654-9dfcdab99f7c", candidate_two: "0423af0e-4b1e-43d4-9a47-559ce17cdd4f", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      # Starting here we have winner candidate vs. one of the made up contenders
      %{id: "5d99c305-7d3e-4279-acc6-e90764139bc2", seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "7e8750c4-2872-4dad-a793-7a6915d8ef75", district: "8", candidates: ["7e8750c4-2872-4dad-a793-7a6915d8ef75", "93f33178-116a-48eb-9033-e599e2525994"], candidate_one: "7e8750c4-2872-4dad-a793-7a6915d8ef75", candidate_two: "93f33178-116a-48eb-9033-e599e2525994", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "79db9a33-e625-45cc-882d-c8da27a1c756", district: "12", candidates: ["79db9a33-e625-45cc-882d-c8da27a1c756", "cbb9d25d-1f2b-4a84-9968-28b97f90e798"], candidate_one: "79db9a33-e625-45cc-882d-c8da27a1c756", candidate_two: "cbb9d25d-1f2b-4a84-9968-28b97f90e798", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 53.3, elect: "adea9986-0c90-4196-9512-def9eb0e68e7", district: "14", candidates: ["adea9986-0c90-4196-9512-def9eb0e68e7", "fb85d774-5e3d-4d43-9bfc-a2dfba5b1ab0"], candidate_one: "adea9986-0c90-4196-9512-def9eb0e68e7", candidate_two: "fb85d774-5e3d-4d43-9bfc-a2dfba5b1ab0", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 57.2, elect: "43838b15-1de6-4a08-af0f-995b58dbf142", district: "16", candidates: ["43838b15-1de6-4a08-af0f-995b58dbf142", "9e391259-4f6c-4750-9890-ff4fad514747"], candidate_one: "43838b15-1de6-4a08-af0f-995b58dbf142", candidate_two: "9e391259-4f6c-4750-9890-ff4fad514747", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "53982e76-2d51-4b2d-aa14-8954ff3edc22", district: "18", candidates: ["53982e76-2d51-4b2d-aa14-8954ff3edc22", "6668b0e6-b43b-45e5-bc61-b946d3b4a942"], candidate_one: "53982e76-2d51-4b2d-aa14-8954ff3edc22", candidate_two: "6668b0e6-b43b-45e5-bc61-b946d3b4a942", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "25881722-e178-47ef-b916-c3574f7fb063", district: "20", candidates: ["25881722-e178-47ef-b916-c3574f7fb063", "b7403749-efd0-4c72-b3e4-15097f4475ba"], candidate_one: "25881722-e178-47ef-b916-c3574f7fb063", candidate_two: "b7403749-efd0-4c72-b3e4-15097f4475ba", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "0ce64757-3bf2-4779-99ca-3b5b35d59c4d", district: "22", candidates: ["0ce64757-3bf2-4779-99ca-3b5b35d59c4d", "d92a4602-25e3-4aed-9bf2-241cdc0fa361"], candidate_one: "0ce64757-3bf2-4779-99ca-3b5b35d59c4d", candidate_two: "d92a4602-25e3-4aed-9bf2-241cdc0fa361", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 53.3, elect: "920f6424-0ca3-4a08-bbd7-b4d4bd0e28d8", district: "24", candidates: ["920f6424-0ca3-4a08-bbd7-b4d4bd0e28d8", "0f71a982-1d18-466b-95da-2d1117a0db66"], candidate_one: "920f6424-0ca3-4a08-bbd7-b4d4bd0e28d8", candidate_two: "0f71a982-1d18-466b-95da-2d1117a0db66", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 57.2, elect: "10b1ff89-2bbb-4b6e-a77a-ca96e822c7b2", district: "26", candidates: ["10b1ff89-2bbb-4b6e-a77a-ca96e822c7b2", "41b2b493-3a0b-46d5-9287-6d1ee2637fcc"], candidate_one: "10b1ff89-2bbb-4b6e-a77a-ca96e822c7b2", candidate_two: "41b2b493-3a0b-46d5-9287-6d1ee2637fcc", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "6f4a6011-e289-453c-ac12-06d25911c83f", district: "28", candidates: ["6f4a6011-e289-453c-ac12-06d25911c83f", "cdd6bf85-e96c-45ea-86aa-fc232cbdd659"], candidate_one: "6f4a6011-e289-453c-ac12-06d25911c83f", candidate_two: "cdd6bf85-e96c-45ea-86aa-fc232cbdd659", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 57.2, elect: "9146213f-4046-41f5-bb56-b099ee0b9779", district: "30", candidates: ["9146213f-4046-41f5-bb56-b099ee0b9779", "2cf2b454-c9f2-47a4-a46d-89317a1d6638"], candidate_one: "9146213f-4046-41f5-bb56-b099ee0b9779", candidate_two: "2cf2b454-c9f2-47a4-a46d-89317a1d6638", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 51.4, elect: "cbfb86db-ec52-479e-a30c-5bd6ffe22979", district: "32", candidates: ["cbfb86db-ec52-479e-a30c-5bd6ffe22979", "f7724ba1-a70d-492c-9310-a54a8de40930"], candidate_one: "cbfb86db-ec52-479e-a30c-5bd6ffe22979", candidate_two: "f7724ba1-a70d-492c-9310-a54a8de40930", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 53.3, elect: "9f73ece1-cb23-49e9-b190-83b652e5301d", district: "34", candidates: ["9f73ece1-cb23-49e9-b190-83b652e5301d", "71b69043-021b-482d-a171-ea0bfe124b0f"], candidate_one: "9f73ece1-cb23-49e9-b190-83b652e5301d", candidate_two: "71b69043-021b-482d-a171-ea0bfe124b0f", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 57.2, elect: "33198d60-fa84-409f-8b0b-f335d689df0e", district: "36", candidates: ["33198d60-fa84-409f-8b0b-f335d689df0e", "10682205-5ea0-4270-9a93-0b77d03aeec3"], candidate_one: "33198d60-fa84-409f-8b0b-f335d689df0e", candidate_two: "10682205-5ea0-4270-9a93-0b77d03aeec3", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "cea32d7e-8e1f-4c20-9e27-41d7a4d2d728", district: "38", candidates: ["cea32d7e-8e1f-4c20-9e27-41d7a4d2d728", "9b901b07-ac46-4e60-825f-32a99af907bd"], candidate_one: "cea32d7e-8e1f-4c20-9e27-41d7a4d2d728", candidate_two: "9b901b07-ac46-4e60-825f-32a99af907bd", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 64.3, elect: "4169f369-f1d2-40a9-9d62-8db88e824e59", district: "40", candidates: ["4169f369-f1d2-40a9-9d62-8db88e824e59", "cba473d7-0162-4da8-ad05-ff3c15275923"], candidate_one: "4169f369-f1d2-40a9-9d62-8db88e824e59", candidate_two: "cba473d7-0162-4da8-ad05-ff3c15275923", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "f3b82e41-e202-4190-85c6-ceb2b73d1791", district: "42", candidates: ["f3b82e41-e202-4190-85c6-ceb2b73d1791", "04dfecbe-290e-4806-8d33-0772cde2686b"], candidate_one: "f3b82e41-e202-4190-85c6-ceb2b73d1791", candidate_two: "04dfecbe-290e-4806-8d33-0772cde2686b", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 63.1, elect: "85291a9d-10d4-4fea-9cab-5ac6d79f2de1", district: "44", candidates: ["85291a9d-10d4-4fea-9cab-5ac6d79f2de1", "810ca1e4-1ffe-4f53-92b7-8664c5692eca"], candidate_one: "85291a9d-10d4-4fea-9cab-5ac6d79f2de1", candidate_two: "810ca1e4-1ffe-4f53-92b7-8664c5692eca", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 57.2, elect: "197a9621-bcaf-4ec7-82c1-ff3983d89032", district: "46", candidates: ["197a9621-bcaf-4ec7-82c1-ff3983d89032", "8ef1ba51-a889-4d63-8bca-d1f3de543d52"], candidate_one: "197a9621-bcaf-4ec7-82c1-ff3983d89032", candidate_two: "8ef1ba51-a889-4d63-8bca-d1f3de543d52", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{seat: :State_Senator, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 54.3, elect: "16657cef-5e9e-48af-8734-254ee77e3db7", district: "48", candidates: ["16657cef-5e9e-48af-8734-254ee77e3db7", "4c103841-db5e-4dce-8451-6b7a0cb60e15"], candidate_one: "16657cef-5e9e-48af-8734-254ee77e3db7", candidate_two: "4c103841-db5e-4dce-8451-6b7a0cb60e15", attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},


      %{seat: :Governor, election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", elect_percentage: 59.7, elect: "0e97798f-503f-4218-a801-c8bb7ff9498b", district: nil, candidates: ["0e97798f-503f-4218-a801-c8bb7ff3498b", "4ed97c3a-15ff-45a7-af6c-6e37bcdb943b"], attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      # 2024
      %{seat: :Senator, election_id: "bfe75d28-b2eb-4478-82f5-17828f9c82c6", elect_percentage: nil, elect: nil, district: nil, candidates: ["9b9b951e-3f3c-4350-8ffb-a36a981e376d", "55f7e3e6-883a-4c4a-b04c-b69bcc741273"], attachments: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},

])

Repo.insert_all(Forum, [
      %{id: "8d04fd4f-1321-4e9f-911a-7369d57d0b55", title: "Issues", desc: "Forum for all generic site related issues. All users will be subscribed.", category: :Site, moderator: "a9f44567-e031-44f1-aae6-972d7aabbb45",
            members: ["a9f44567-e031-44f1-aae6-972d7aabbb45"], updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "a837b808-b122-4b07-9cbd-576473165fcb", title: "2024 Election", desc: "It's almost here.", category: :Politics, moderator: "b5f44567-e031-44f1-aae6-972d7aabbb45",
            members: ["b5f44567-e031-44f1-aae6-972d7aabbb45"], updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "3f826aed-ab18-47d3-80b5-b20328db4e0f", title: "User's Forum", desc: "Forum moderated by non-admin member", category: :Politics, moderator: "df18d5eb-e99e-4481-9e16-4d2f434a3711",
            members: ["67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", "df18d5eb-e99e-4481-9e16-4d2f434a3711"], updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "acc8123d-d79e-416c-890f-7e56a51ffe32", title: "General Forum", desc: "General Forum", category: :General, moderator: "df18d5eb-e99e-4481-9e16-4d2f434a3711",
            members: ["df18d5eb-e99e-4481-9e16-4d2f434a3711", "b5f44567-e031-44f1-aae6-972d7aabbb45"], updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "c6643e31-52a3-4936-ab15-c81f0fe29ab8", title: "The Nebraska Unicameral", desc: "A place to discuss the system of government unique to the State of Nebraska.", category: :General, moderator: "df18d5eb-e99e-4481-9e16-4d2f434a3711",
            members: ["df18d5eb-e99e-4481-9e16-4d2f434a3711", "b5f44567-e031-44f1-aae6-972d7aabbb45"], updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()}

])

Repo.insert_all(Thread, [
      %{id: "acdd24e9-adc8-4ddc-969b-cc7bd7085e2f", title: "Seeking Help with Common Issues", creator: "a9f44567-e031-44f1-aae6-972d7aabbb45", forum_id: "8d04fd4f-1321-4e9f-911a-7369d57d0b55",
            content: "Welcome to the Issues thread. This is the site admin writing to make sure that everyone knows who to contact if they are having issues with anything on the site. Please visit the ____",
            likes: 0, shares: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "f254a438-f49b-4f42-9f72-ba76951c3846", title: "No Posts In Here", creator: "a9f44567-e031-44f1-aae6-972d7aabbb45", forum_id: "8d04fd4f-1321-4e9f-911a-7369d57d0b55",
            content: "This is the 2nd test of the Issues Thread. We're giving this one some upvotes and downvotes as well :)", likes: 0, shares: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "70a4ea60-9bbc-4755-b249-d39db020c683", title: "Who Do You Think is Going to Win for Governor?", creator: "a9f44567-e031-44f1-aae6-972d7aabbb45", forum_id: "a837b808-b122-4b07-9cbd-576473165fcb",
            content: "This is the test of the Elections Thread", likes: 0, shares: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "dd9ea23d-00ca-4f64-9226-dd95b86747b6", title: "User Forum Thread One", creator: "df18d5eb-e99e-4481-9e16-4d2f434a3711", forum_id: "3f826aed-ab18-47d3-80b5-b20328db4e0f",
            content: "This is the test of the User Forum Thread", likes: 0, shares: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "8a186b37-06d9-4853-86d2-9363fa78eab4", title: "General Forum Guidelines", creator: "a9f44567-e031-44f1-aae6-972d7aabbb45", forum_id: "acc8123d-d79e-416c-890f-7e56a51ffe32",
            content: "Please read the following guideliens before ...", likes: 3, shares: 2, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "7e37664a-b475-4a92-a354-8d95a7d66abc", title: "Second User", creator: "b5f44567-e031-44f1-aae6-972d7aabbb45", forum_id: "3f826aed-ab18-47d3-80b5-b20328db4e0f",
            content: "This is the test of the Elections Thread", likes: 0, shares: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "00411e71-e465-43c5-8521-66edbee07171", title: "Misc Thread", creator: "a9f44567-e031-44f1-aae6-972d7aabbb45", forum_id: "a837b808-b122-4b07-9cbd-576473165fcb",
            content: "Just something of the misx category here. Maybe I will come back in and formulate something big and fancy", likes: 0, shares: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "208272e9-1765-451f-9acb-79699ce5fc25", title: "The Unicameral Needs to Die!", creator: "b2f44567-e031-44f1-aae6-972d7aabbb45", forum_id: "c6643e31-52a3-4936-ab15-c81f0fe29ab8",
            content: "I know that it is a unique system and that it brings many advantages, but I think that the fact that much of our own population fails to u nderstand seems to have the opposite effect in a lot of our state policies",
            likes: 0, shares: 2, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "4fd6aa47-51da-4277-bca6-3a87b2153c20", title: "Interesting Facts I Learned about the Unicameral", creator: "b2f44567-e031-44f1-aae6-972d7aabbb45", forum_id: "c6643e31-52a3-4936-ab15-c81f0fe29ab8",
            content: "Every now and then I just stumble across intersting facts and just figured that I would have to share them",
            likes: 4, shares: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "b2a8dcab-1d6f-45d3-9356-95713abc0669", title: "You Should Follow What the Great State of Minnesota Does", creator: "67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", forum_id: "c6643e31-52a3-4936-ab15-c81f0fe29ab8",
            content: "Every now and then I just stumble across intersting facts and just figured that I would have to share them",
            likes: 0, shares: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "af3d214f-7761-4ba4-af26-0faf07c368ba", title: "Minnesota Users Seem to be Lacking Around Here", creator: "67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", forum_id: "3f826aed-ab18-47d3-80b5-b20328db4e0f",
            content: "I certainly hope that this can change soon because it is always nice to have a wide variety of poeople on a platform such as this one.",
            likes: 0, shares: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "ad9952fb-dff9-4bc5-b1c5-ef0a6cc38316", title: "Differences in States - E.g. Minnesota vs. Nebraska", creator: "67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", forum_id: "acc8123d-d79e-416c-890f-7e56a51ffe32",
            content: "This is one of those posts that are from the Minnesota person and he is being followed by a certain subset of people to make it better to debug. God bless him.",
            likes: 0, shares: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()}
])

Repo.insert_all(Post, [
      %{id: Ecto.UUID.generate(), title: "Reset Password", author: "a9f44567-e031-44f1-aae6-972d7aabbb45", thread_id: "acdd24e9-adc8-4ddc-969b-cc7bd7085e2f",
            content: "Is there a simple way to find instructions on how to get a password reset?",
            upvotes: 7, downvotes: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: Ecto.UUID.generate(), title: "", author: "a9f44567-e031-44f1-aae6-972d7aabbb45", thread_id: "acdd24e9-adc8-4ddc-969b-cc7bd7085e2f",
            content: "This is a follow up post. You can also email the support team at support@fancan.org and they will respond to your inquiries ASAP",
            upvotes: 6, downvotes: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "59e92082-6cc8-435d-9e71-59d3c89c9867", title: "Election Post", author: "a9f44567-e031-44f1-aae6-972d7aabbb45", thread_id: "70a4ea60-9bbc-4755-b249-d39db020c683",
            content: "Hello and welcome to the Elections thread.  I wanted to make the first post and just set the stage for the discussion. Please be civil and always keep in mind the goal is the facilitation of public sector knowldge",
            upvotes: 0, downvotes: 1, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "956c5b4f-f1a1-42f0-b04d-bd80eddbe997", title: "User Forum Post One", author: "df18d5eb-e99e-4481-9e16-4d2f434a3711", thread_id: "dd9ea23d-00ca-4f64-9226-dd95b86747b6",
            content: "This is just to show that each user can create their own thread and then of course comment and post on those or other thread.",
            upvotes: 1, downvotes: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: Ecto.UUID.generate(), title: "General Forum Guidelines", author: "a9f44567-e031-44f1-aae6-972d7aabbb45", thread_id: "8a186b37-06d9-4853-86d2-9363fa78eab4",
            content: "Please read the following guideliens before ...", upvotes: 3, downvotes: 2, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "566f949a-be08-49e7-9c60-0c33d55b791b", title: "Second User", author: "b5f44567-e031-44f1-aae6-972d7aabbb45", thread_id: "7e37664a-b475-4a92-a354-8d95a7d66abc",
            content: "This is the test of the Elections Post", upvotes: 1, downvotes: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "1f310d22-6abb-4b9f-942a-53aafd7f2006", title: "Query Test", author: "b5f44567-e031-44f1-aae6-972d7aabbb45", thread_id: "7e37664a-b475-4a92-a354-8d95a7d66abc",
            content: "Needed two posts from Jim to test a query", upvotes: 0, downvotes: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: Ecto.UUID.generate(), title: "Misc Post", author: "a9f44567-e031-44f1-aae6-972d7aabbb45", thread_id: "00411e71-e465-43c5-8521-66edbee07171",
            content: "Just something of the misx category here. Maybe I will come back in and formulate something big and fancy", upvotes: 0, downvotes: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "9de1ea76-ce5a-447f-a809-7b62dcbfa3a7", title: "I Disagree", author: "b2f44567-e031-44f1-aae6-972d7aabbb45", thread_id: "208272e9-1765-451f-9acb-79699ce5fc25",
            content: "I get what you are saying here, and I have in fact seen some of that myself, but I think that it is something to be overcome instead.",
            upvotes: 0, downvotes: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "01d9b7cf-4684-43bc-8b20-fc5e1ff56420", title: "Back in Minnesota there is a certain way that we do things", author: "67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", thread_id: "dd9ea23d-00ca-4f64-9226-dd95b86747b6",
            content: "I get what you are saying here, and I have in fact seen some of that myself, but I think that it is something to be overcome instead.",
            upvotes: 0, downvotes: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "3ab6efb5-d84f-4932-bd21-cfac11763407", title: "Minnesota seems be blocked from the VPN", author: "67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", thread_id: "acdd24e9-adc8-4ddc-969b-cc7bd7085e2f",
            content: "I am trying to connect here so that I can vote vote vote, but I cannot seem to get through. I wonder if there is some kind of weird firewall issue that seems to be interrupting the flow here. One of these days I think that we should all rallly together and really come up with some solutions here. But until then, I guess, I will just wait and see what your response is",
            upvotes: 0, downvotes: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "9d44f5fd-4016-462e-85f9-bb41f2ac8692", title: "Can People From Minnesota Vote in Other State Elections?", author: "67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", thread_id: "acdd24e9-adc8-4ddc-969b-cc7bd7085e2f",
            content: "I get what you are saying here, and I have in fact seen some of that myself, but I think that it is something to be overcome instead.",
            upvotes: 0, downvotes: 0, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()}

])

Repo.insert_all(Ballot, [
      %{id: "0bf74d8b-edc4-432c-a1db-732168966ea3", election_id: "bfe75d28-b2eb-4478-82f5-17828f9c82c6", user_id: nil, vote_map: %{}, columns: 3, attachment: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{id: "52e101ec-4106-4603-9be4-782c9d42299f", election_id: "a1f44567-e031-44f1-aae6-972d7aabbb45", user_id: nil, vote_map: %{}, columns: 4, attachment: nil, updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()}
])
# "Follow" = "Subscribe"


Repo.insert_all(Hold, [
      # Jim went to town and chose them all
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :follow, hold_cat: :race, hold_cat_id: "5d99c305-7d3e-4279-acc6-e90764139bc2", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :alert, hold_cat: :race, hold_cat_id: "5d99c305-7d3e-4279-acc6-e90764139bc2", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :star, hold_cat: :race, hold_cat_id: "5d99c305-7d3e-4279-acc6-e90764139bc2", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :bookmark, hold_cat: :race, hold_cat_id: "5d99c305-7d3e-4279-acc6-e90764139bc2", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},

      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :follow, hold_cat: :user, hold_cat_id: "a9f44567-e031-44f1-aae6-972d7aabbb45", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", type: :follow, hold_cat: :user, hold_cat_id: "a9f44567-e031-44f1-aae6-972d7aabbb45", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", type: :follow, hold_cat: :user, hold_cat_id: "a9f44567-e031-44f1-aae6-972d7aabbb45", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b2f44567-e031-44f1-aae6-972d7aabbb45", type: :follow, hold_cat: :user, hold_cat_id: "a9f44567-e031-44f1-aae6-972d7aabbb45", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      # We got two friends - Jim holds Aaron & Aaron holds Jim
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :follow, hold_cat: :user, hold_cat_id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", type: :follow, hold_cat: :user, hold_cat_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      # Aaron chose 2
      # Jim & Aaron subscribe to Pres Election
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :follow, hold_cat: :election, hold_cat_id: "bfe75d28-b2eb-4478-82f5-17828f9c82c6", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", type: :follow, hold_cat: :election, hold_cat_id: "bfe75d28-b2eb-4478-82f5-17828f9c82c6", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      # Aaron chose 2
      # Jim like Mike & Mirch & Sarah because WTF radio
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :vote, hold_cat: :candidate, hold_cat_id: "0e91778f-503f-4218-a801-c8bb7ff9498b", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :vote, hold_cat: :candidate, hold_cat_id: "0ce64757-3bf2-4779-99ca-3b5b35d59c4d", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :vote, hold_cat: :candidate, hold_cat_id: "049acd0a-427b-4096-8cd5-1ce59845649e", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :vote, hold_cat: :candidate, hold_cat_id: "09f131ac-818c-4058-b9ce-dc3b91794416", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      # Post Hold Jim & Aaron
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :upvote, hold_cat: :post, hold_cat_id: "956c5b4f-f1a1-42f0-b04d-bd80eddbe997", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :upvote, hold_cat: :post, hold_cat_id: "59e92082-6cc8-435d-9e71-59d3c89c9867", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :upvote, hold_cat: :post, hold_cat_id: "566f949a-be08-49e7-9c60-0c33d55b791b", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :upvote, hold_cat: :post, hold_cat_id: "1f310d22-6abb-4b9f-942a-53aafd7f2006", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :upvote, hold_cat: :post, hold_cat_id: "9de1ea76-ce5a-447f-a809-7b62dcbfa3a7", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", type: :upvote, hold_cat: :post, hold_cat_id: "566f949a-be08-49e7-9c60-0c33d55b791b", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      # Thread Hold Jim & Aaron
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :share, hold_cat: :thread, hold_cat_id: "208272e9-1765-451f-9acb-79699ce5fc25", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", type: :share, hold_cat: :thread, hold_cat_id: "208272e9-1765-451f-9acb-79699ce5fc25", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :like, hold_cat: :thread, hold_cat_id: "4fd6aa47-51da-4277-bca6-3a87b2153c20", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", type: :like, hold_cat: :thread, hold_cat_id: "4fd6aa47-51da-4277-bca6-3a87b2153c20", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      # Favorites for Jim & Aaron
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :favorite, hold_cat: :thread, hold_cat_id: "208272e9-1765-451f-9acb-79699ce5fc25", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :favorite, hold_cat: :post, hold_cat_id: "566f949a-be08-49e7-9c60-0c33d55b791b", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "b5f44567-e031-44f1-aae6-972d7aabbb45", type: :favorite, hold_cat: :user, hold_cat_id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{user_id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", type: :favorite, hold_cat: :thread, hold_cat_id: "4fd6aa47-51da-4277-bca6-3a87b2153c20", updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()}
])
# I need a generic opponent to load for the ballots for now (during offseason)
Repo.insert_all(Legislator, [
      %{
            people_id: 99999, person_hash: "ababababab", party_id: "6", state_id: 00, party: "N", role_id: 2, role: "Sen", name: "Jim Opponent", first_name: "Jim", middle_name: "", last_name: "Oppponent", suffix: "",
            nickname: "", district: "SD-014", ftm_eid: nil, votesmart_id: nil, opensecrets_id: "", knowwho_pid: nil, ballotpedia: "", bioguide_id: "", committee_sponsor: 0, committee_id: 0, state_federal: 0}
])

#Authorization Roles
Repo.insert_all(Authorize, [
      # Jim went to town and chose them all
      %{id: Ecto.UUID.generate(),
            role: :reader,

            read: %{:user=> true, :candidate => true, :election => true, :ballot => true, :forum => true, :post => true, :thread => true, :race => true},
            edit: %{},
            create: %{},
            delete: %{},

            updated_at: NaiveDateTime.local_now(),
            inserted_at: NaiveDateTime.local_now()},

      %{id: Ecto.UUID.generate(),
            role: :voter,

            read: %{:user=> true, :candidate => true, :election => true, :ballot => true, :forum => true, :post => true, :thread => true, :race => true},
            # permissions will allow editing of post, but still depend on ownership if can truly edit
            edit: %{:ballot => true, :post => true, :thread => true},
            create: %{:post => true, :thread => true},
            delete: %{:post => true, :thread => true},

            updated_at: NaiveDateTime.local_now(),
            inserted_at: NaiveDateTime.local_now()},

      %{id: Ecto.UUID.generate(),
            role: :admin,

            read: %{:user=> true, :candidate => true, :election => true, :ballot => true, :forum => true, :post => true, :thread => true, :race => true},
            edit: %{:user=> true, :candidate => true, :election => true, :ballot => true, :forum => true, :post => true, :thread => true, :race => true},
            create: %{:user=> true, :candidate => true, :election => true, :ballot => true, :forum => true, :post => true, :thread => true, :race => true},
            delete: %{:user=> true, :candidate => true, :election => true, :ballot => true, :forum => true, :post => true, :thread => true, :race => true},

            updated_at: NaiveDateTime.local_now(),
            inserted_at: NaiveDateTime.local_now()},

      %{id: Ecto.UUID.generate(),
            role: :candidate,

            read: %{:candidate => true},
            edit: %{:candidate => true},
            create: %{:forum => true, :post => true, :thread => true, :race => true},
            delete: %{},

            updated_at: NaiveDateTime.local_now(),
            inserted_at: NaiveDateTime.local_now()}
])
# Ecto.UUID.bingenerate()
