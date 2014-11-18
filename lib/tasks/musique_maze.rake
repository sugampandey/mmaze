namespace :musique_maze do
  desc "Seed Initial Categories"
  task :generate_categories => :environment do
    Category.create({:name => "BANDS/MUSICAL GROUPS", :published => true})
    Category.create({:name => "TOP 15 SONGS AND ONE HIT WONDERS - 1950's", :published => true})
    Category.create({:name => "TOP 10 SONGS BY BAND/ARTIST", :published => true})
    Category.create({:name => "MUSICIAN'S/ARTIST'S NAMES", :published => true})
    Category.create({:name => "TOP 15 SONGS AND ONE HIT WONDERS - 1960's", :published => true})
    Category.create({:name => "CONVERSATIONS USING SONG TITLES", :published => true})
    Category.create({:name => "SONGS BY SUBJECT", :published => true})
    Category.create({:name => "TOP 15 SONGS AND ONE HIT WONDERS - 1970's", :published => true})
    Category.create({:name => "THE BEATLES", :published => true})
    Category.create({:name => "SONG TITLE GROUPINGS", :published => true})
    Category.create({:name => "TOP 15 SONGS AND ONE HIT WONDERS - 1980's", :published => true})
    Category.create({:name => "SONG LYRICS", :published => true})
    Category.create({:name => "SHARED WORDS IN SONG TITLES", :published => true})
    Category.create({:name => "TOP 15 SONGS AND ONE HIT WONDERS - 1990's", :published => true})
    Category.create({:name => "MISCELLANEOUS QUIZZES", :published => true})
    Category.create({:name => "BANDS / MUSICAL GROUPS", :published => true})
    Category.create({:name => "TOP 15 SONGS AND ONE HIT WONDERS - 1950's", :published => true})
  end
  
  desc "Seed Initial Quiz"
  task :generate_initial_quizzes, [:file] => :environment  do |t, args|
    require 'document_parser'
    DocumentParser::parse_quizzes_document(args[:file])
  end

  desc "Seed Additional Quizzes"
  task :seed_additional_quizzes, [:root_dir] => :environment  do |t, args|
    require 'document_parser'
    Dir["#{args[:root_dir]}/**/*"].reject {|fn| File.directory?(fn) }.each do |d| 
      category = DocumentParser.parse_quizzes_document("#{Rails.root}/" + d, false, true)
      seeder = category.seeder
      if seeder.nil? 
        seeder = category.build_seeder
      end
      seeder.doc = File.open("#{Rails.root}/" + d)
      seeder.save
    end
  end
  
  desc "Seed Initial Quiz for BANDS/MUSICAL GROUPS"
  task :generate_quizes => :environment do
    cat = Category.find_by_name("BANDS/MUSICAL GROUPS")
    Quiz.create({:name => "\"BAND\" BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "\"BLUE\" BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "\"FRUITY\" BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "3 LETTER ONE NAME BANDS", :category_id => cat.id})
    Quiz.create({:name => "4 LETTER ONE NAME BANDS", :category_id => cat.id})
    Quiz.create({:name => "5 LETTER ONE NAME BANDS", :category_id => cat.id})
    Quiz.create({:name => "6 LETTER ONE NAME BANDS", :category_id => cat.id})
    Quiz.create({:name => "AUSTRALIAN BANDS", :category_id => cat.id})
    Quiz.create({:name => "BAND NAMES - INITIALLY SPEAKING", :category_id => cat.id})
    Quiz.create({:name => "BAND NAMES ENDING IN \"S\" WITHOUT \"THE\"", :category_id => cat.id})
    Quiz.create({:name => "BAND NAMES WITH NO VOWELS", :category_id => cat.id})
    Quiz.create({:name => "BANDS WITH SIBLING MEMBERS", :category_id => cat.id})
    Quiz.create({:name => "BEFORE AND AFTER BAND NAMES (3COLUMNS)", :category_id => cat.id})
    Quiz.create({:name => "COLORFUL BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "EXCLUSIVELY \"E\" BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "FICTIONAL PEOPLE IN BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "FOOD BANDS", :category_id => cat.id})
    Quiz.create({:name => "INITIALS IN BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "INSTRUMENTAL BANDS/ARTISTS", :category_id => cat.id})
    Quiz.create({:name => "LOCATIONS IN BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "LONG ONE WORD \"THE\" BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "LOS ANGELES AREA BANDS", :category_id => cat.id})
    Quiz.create({:name => "MISSPELLED BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "MUSICAL DUETS", :category_id => cat.id})
    Quiz.create({:name => "MUSICAL THREESOMES", :category_id => cat.id})
    Quiz.create({:name => "NUMBERS 10 OR HIGHER IN BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "ONE NAME BANDS - 10 OR MORE LETTERS", :category_id => cat.id})
    Quiz.create({:name => "ONE NAME BANDS - 7 LETTERS", :category_id => cat.id})
    Quiz.create({:name => "ONE NAME BANDS - 8 LETTERS", :category_id => cat.id})
    Quiz.create({:name => "ONE NAME BANDS - 9 LETTERS", :category_id => cat.id})
    Quiz.create({:name => "ONE NAME SINGERS AND THEIR BANDS", :category_id => cat.id})
    Quiz.create({:name => "RHYMING BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "RHYMING BEATLES SONG TITLES", :category_id => cat.id})
    Quiz.create({:name => "SAME LETTER COUNT - BAND AND SONG", :category_id => cat.id})
    Quiz.create({:name => "SAN FRANICISCO BAY AREA BANDS", :category_id => cat.id})
    Quiz.create({:name => "SCARY BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "SPECIAL CHARACTERS IN BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "STRAIGHT \"A's\" BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "THE BEATLES BREAKUP SONGS", :category_id => cat.id})
    Quiz.create({:name => "THE BEATLES LOVE SONGS", :category_id => cat.id})
    Quiz.create({:name => "THE NUMBER 4 IN BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "THE NUMBER 5 IN BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "TWO NAME BANDS WITH SAME INITIAL", :category_id => cat.id})
    Quiz.create({:name => "SWINGED BAND NAMES", :category_id => cat.id})
    Quiz.create({:name => "BRITISH INVASION BANDS - 1960's", :category_id => cat.id})
    Quiz.create({:name => "BRITISH INVASION BANDS - 1980's", :category_id => cat.id})
  end
end
