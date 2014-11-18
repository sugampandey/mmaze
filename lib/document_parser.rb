module DocumentParser
  def self.parse_quiz_doc(file_path)
    document_hash = []
    if file_path.match(/xlsx/)
      doc = Excelx.new(file_path)
    else
      doc = Excel.new(file_path)
    end

    doc.default_sheet = doc.sheets.first
    sheet_hash = {}
    question_section_not_found = true
    not_last_content = true
    row = 0
    answer_columns = []

    puts "Determining Quiz attributes"
    while question_section_not_found and not_last_content do
      row_content = doc.cell(row, 1)
      not_last_content = (row_content != doc.last_row)
      
      unless row_content.nil? 
        
        if row_content == "Category Name"
          sheet_hash[:quiz_category_name] = doc.cell(row, 2)
        end

        if row_content == "Quiz Name"
          sheet_hash[:quiz_name] = doc.cell(row, 2) 
        end

        if row_content == "Content"
          sheet_hash[:quiz_content] = doc.cell(row, 2)
        end

        if row_content == "Instructions"
          sheet_hash[:instructions] = [] if sheet_hash[:instructions].nil?
          sheet_hash[:instructions] << doc.cell(row, 2)
        end 
        
        # when quiz has answer column, define the columns 
        if row_content == "Answer column"
          sheet_hash[:answer_columns] = [] if sheet_hash[:answer_columns].nil?
          answer_columns << doc.cell(row, 2) 
          sheet_hash[:answer_columns] << doc.cell(row, 2) 
          #FIXME: handle more than 2 answer columns
          unless doc.cell(row, 3).nil?
            answer_columns << doc.cell(row, 3)
            sheet_hash[:answer_columns] << doc.cell(row, 2) 
          end
        end
        # terminate when questions attribute has come
        question_section_not_found = false if row_content == "Questions"
      end
      row += 1
    end

    puts "Determining Columns for Quiz"
    # on questions list entries
    # define which answers and clue column names and indexes in the sheet
    still_has_columns = true
    answer_column_indexes = []
    clue_column_indexes = []
    clue_columns = []
    column = 1

    sheet_hash[:columns] = []

    # start to parse the list entries for questions to determine the answers and clues column
    still_has_columns = !doc.cell(row, column).nil?
    while still_has_columns do
      coll_content = doc.cell(row, column)
      
      # when index is the answer colum
      if answer_columns.include?(coll_content) 
        answer_column_indexes << column
        sheet_hash[:columns] << { :name => coll_content, :is_answer => true }
      else # when index is the clue colum
        clue_columns << coll_content
        clue_column_indexes << column
        sheet_hash[:columns] << { :name => coll_content, :is_answer => false }
      end
      
      column += 1
      still_has_columns = !doc.cell(row, column).nil?
    end
    row += 1

    puts "Read Questions in Quiz"
    column = 1
    not_last_row = !doc.cell(row, 1).nil?
    questions = []
    while not_last_row do
      column = 1
      column_index = 0 
      question_contents = []  
      not_last_column = !doc.cell(row, column).nil?
      while not_last_column do
        content = doc.cell(row, column)
        content = content.to_s        
        column += 1
        content.split("|").each do |x| 
          question_contents << { :column => sheet_hash[:columns][column_index][:name], :content => x } 
        end
        column_index += 1
        not_last_column = !doc.cell(row, column).nil?
      end

      questions << question_contents

      row += 1
      not_last_row = !doc.cell(row, 1).nil?
    end
    sheet_hash[:questions] = questions
    return sheet_hash
  end

  def self.parse_quizzes_document(file_path, purge=true, seed_category=false)
    #FIXME: handle potential infinity loop
    raise 'Please enter file path' if file_path.blank?
    document_hash = []
    Quiz.transaction do
      
      if file_path.match(/xlsx/)
        doc = Excelx.new(file_path)
      else
        doc = Excel.new(file_path)
      end
      
      if purge
        Quiz.destroy_all  
      end

      if seed_category
        begin
          doc.default_sheet = doc.sheets[0]
          @category = Category.find_by_name(doc.cell(2, 2)) 
        rescue Exception => e

        end
      end

      doc.sheets.each do |sh|
        begin
          puts "Processing sheet: #{sh}"
          doc.default_sheet = sh
          sheet_hash = {}
          question_section_not_found = true
          not_last_content = true
          row = 0
          answer_columns = []
          quiz = Quiz.new

          puts "Determining Quiz attributes"
          while question_section_not_found and not_last_content do
            row_content = doc.cell(row, 1)
            
            not_last_content = (row_content != doc.last_row)
            
            unless row_content.nil? 
              
              if row_content == "Category Name"
                quiz.category = Category.find_by_name(doc.cell(row, 2)) 
                sheet_hash[:quiz_category_name] = doc.cell(row, 2)
              end

              if row_content == "Quiz Name"
                if eq = Quiz.find_by_name(doc.cell(row, 2))
                  quiz = eq
                  quiz.instructions.destroy_all
                  quiz.columns.destroy_all
                  quiz.questions.destroy_all
                else
                  quiz.name = doc.cell(row, 2)
                end 
                sheet_hash[:quiz_category_name] = doc.cell(row, 2) 
              end

              if row_content == "Content"
                quiz.content = doc.cell(row, 2) 
              end

              if row_content == "Instructions"

                quiz.instructions.build(:content => doc.cell(row, 2)) 
                sheet_hash[:instructions] = [] if sheet_hash[:instructions].nil?
                sheet_hash[:instructions] << doc.cell(row, 2)
              end 
              
              # when quiz has answer column, define the columns 
              if row_content == "Answer column"
                sheet_hash[:answer_columns] = [] if sheet_hash[:answer_columns].nil?
                answer_columns << doc.cell(row, 2) 
                sheet_hash[:answer_columns] << doc.cell(row, 2) 
                #FIXME: handle more than 2 answer columns
                unless doc.cell(row, 3).nil?
                  answer_columns << doc.cell(row, 3)
                  sheet_hash[:answer_columns] << doc.cell(row, 2) 
                end
              end
              # terminate when questions attribute has come
              question_section_not_found = false if row_content == "Questions"
            end
            row += 1
          end

          quiz.save
          
          sheet_hash[:quiz_name] = quiz.name
          sheet_hash[:content] = quiz.content
          sheet_hash[:instructions] = quiz.instructions.map{|i| i.content }
          sheet_hash[:answer_columns] = answer_columns
          sheet_hash[:questions] = {}
          sheet_hash[:questions][:columns_titles] = []


          puts "Determining Columns for Quiz"
          # on questions list entries
          # define which answers and clue column names and indexes in the sheet
          still_has_columns = true
          answer_column_indexes = []
          clue_column_indexes = []
          clue_columns = []
          column = 1

          # start to parse the list entries for questions to determine the answers and clues column
          still_has_columns = !doc.cell(row, column).nil?
          while still_has_columns do
            coll_content = doc.cell(row, column)
            
            # when index is the answer colum
            if answer_columns.include?(coll_content) 
              answer_column_indexes << column
              sheet_hash[:questions][:columns_titles] = [] if sheet_hash[:questions][:columns_titles].nil?
              sheet_hash[:questions][:columns_titles] << coll_content
              c = quiz.columns.build(:name => coll_content, :is_answer => 1)
            else # when index is the clue colum
              clue_columns << coll_content
              clue_column_indexes << column
              sheet_hash[:questions][:columns_titles] = [] if sheet_hash[:questions][:columns_titles].nil?
              sheet_hash[:questions][:columns_titles] << coll_content
              c = quiz.columns.build(:name => coll_content, :is_answer => 0)
            end
            
            column += 1
            # when entries still there
            still_has_columns = !doc.cell(row, column).nil?
          end
          row += 1

          # setup the numbers of clue and answer columns
          quiz.clue_columns_count = clue_column_indexes.size
          quiz.answer_columns_count = answer_column_indexes.size
          quiz.save

          sheet_hash[:questions][:columns_content] = []

          puts "Read Questions in Quiz"
          column = 1
          not_last_row = !doc.cell(row, 1).nil?
          while not_last_row do
            columns_content = []
            column = 1
            question = quiz.questions.build
            question.save
            
            not_last_column = !doc.cell(row, column).nil?
            while not_last_column do
              content = doc.cell(row, column)
              content = content.to_s
              if col = answer_column_indexes.index(column)
                question_column = quiz.columns.find_by_name(answer_columns[col])
                content.split("|").each_with_index do |split_content, idx|
                  question.answers.build(:content => split_content, :points => 5.0, :column_id => question_column.id, :primary => (idx == 0))
                  columns_content << split_content
                end
              elsif col = clue_column_indexes.index(column)
                current_clue_column = quiz.columns.find_by_name(clue_columns[col])
                question.clues.build(:content => content, :column_id => current_clue_column.id)
                columns_content << content
              end
              
              column += 1

              not_last_column = !doc.cell(row, column).nil?
            end
            
            question.save
            row += 1
            sheet_hash[:questions][:columns_content] << columns_content 
            not_last_row = !doc.cell(row, 1).nil?
          end
          
          quiz.save
          document_hash << sheet_hash
        rescue Exception => e
          next
        end
      end
    end

    return seed_category ? @category : document_hash
  end
end