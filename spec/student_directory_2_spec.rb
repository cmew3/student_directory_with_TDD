require 'student_directory'
require 'date'

describe 'Student directory' do

	let(:sarah)   { {:name=>"Sarah", :cohort => :June}      }
	let(:edward)  { {:name=>"Edward", :cohort => :November} }
	let(:anna)    { {:name=>"anna", :cohort => :June}       }

	context 'when inputting new students' do

		it 'take an input from the user' do
			input = "hello"
			allow(self).to receive(:gets).and_return("hello")
			expect(take_user_input).to eq input
		end

		it 'asks the user for a name' do
			request_name_input = "Please enter student name."
			expect(self).to receive(:show).with(request_name_input)
	     	ask_for_data("student name")
	    end

	    it 'ask the user for cohort' do 
	     	request_cohort_input = "Please enter cohort."
	     	expect(self).to receive(:show).with(request_cohort_input)
	     	ask_for_data('cohort')
	    end

	    context 'when inputting a cohort' do

		    it 'knows that a june cohort is valid' do
		     	expect(is_cohort_valid?("june")).to be true
		    end

		    it 'knows that a banana cohort is not valid' do
		     	expect(is_cohort_valid?("banana")).to be false
		    end

		    it 'only records cohort if valid' do
		     	allow(self).to receive(:take_user_input).and_return("banana","banana","june", "banana")
		     	expect(get_input("cohort")).to eq "june"
		    end

		 end

	    it 'does not ask for another input if name is banana' do
	     	allow(self).to receive(:take_user_input).and_return("banana","banana","june", "banana")
	     	expect((get_input("name"))).to eq("banana")
	    end

	    it 'creates a student with name and cohort' do 
	     	name = "Sarah"
	     	cohort = :June
	     	new_student = {:name => name, :cohort => cohort}
	     	expect(create_student(name,cohort)).to eq new_student
	    end

	    it 'adds the student to the list' do 
	     	new_student = {:name=>"Sarah", :cohort => :June}
	     	expect(add_student_to_list(new_student)).to eq [new_student]
	    end

	    it 'adds a second student to the list' do 
	     	add_student_to_list(sarah)
	     	expect(students).to eq [sarah]
	     	add_student_to_list(edward)
	     	expect(students).to eq [sarah, edward]
	 	end

	 	it 'gets details of new student' do 
	 		allow(self).to receive(:get_inputs).and_return(["bob", "June"])
	 		expect(get_details_of_new_student).to eq({:name=>"bob", :cohort=> :June})
	 	end

	 	it 'gets the required number of inputs' do 
	 		expect(self).to receive(:get_input).exactly(3).times
	 		get_inputs(["a","b","c"])
	 	end
	 end

	context 'when at the input students menu' do
	 	it 'keeps looping until user selects "N"' do
	 		allow(self).to receive(:take_user_input).and_return("Y","Y","N")
	 		expect(self).to receive(:process_add_new_student_choice).exactly(3).times
	 		input_students
	 	end

	 	it 'keeps asking for new students while user enters "Y"' do
	 		allow(self).to receive(:take_user_input).and_return("Y", "Sarah", "June", "Y", "Edward", "may", "N")
	 		allow(input_students)
	 		expect(students.count).to eq 2
	 	end

	 	it 'counts the number of students when the array is not empty when pressed "N"' do 
	     	add_student_to_list(sarah)
	     	add_student_to_list(edward)
	     	allow(self).to receive(:take_user_input).and_return("N")
	 		expect(self).to receive(:print_footer)
	 		input_students
		end
	end

	context 'when asked to print students' do

		def expect_to_show(students)
			students.each do |student|
				expect(self).to receive(:show).with("#{student[:name].capitalize} is in the #{student[:cohort].capitalize} cohort")
			end
		end

		
		it 'prints a student' do
			expect(self).to receive(:show).with("Sarah is in the June cohort")
			print_student(sarah)
		end
	
		it 'prints another student' do
			expect(self).to receive(:show).with("Edward is in the November cohort")
			print_student(edward)
		end

		it 'prints a list of students' do
			students = [sarah, edward]
			expect_to_show(students)
			print_student_list(students)
		end

		it 'prints another list of students' do
			students = [anna, edward]
			expect_to_show(students)
			print_student_list(students)
		end

		it 'prints a header' do
			expect(self).to receive(:show).with("The students at Makers Academy are:\n=====================================")
			print_header
		end

		it 'prints a footer with 3 students' do
			students = [anna,edward,sarah]
			expect(self).to receive(:show).with("There are 3 students in the directory")
			print_footer(students)
		end

		it 'prints a footer with 1 student' do
			students = [anna]
			expect(self).to receive(:show).with("There is 1 student in the directory")
			print_footer(students)
		end

	end

	context 'when listing students by cohort month' do

		it 'lists the november students only' do
			students = [edward,anna,sarah]
			expect(select_by_month("November",students)).to eq([edward])
		end

		it 'lists the june students only' do
			students = [edward,anna,sarah]
			expect(select_by_month("June",students)).to eq([anna,sarah])
		end

		it 'prints only the month headers with non zero numbers of students' do
			students = [edward,anna,sarah]
			expect(self).to receive(:print_month_header).exactly(1).times.with("June")
			expect(self).to receive(:print_month_header).exactly(1).times.with("November")
			expect(self).not_to receive(:print_month_header).with("March")
			print_students_by_month(students)
		end

		def expect_to_display(students)
			Date::MONTHNAMES.compact.each do |month|
				selected_month_students = select_by_month(month,students)
				if selected_month_students.length!=0
					expect(self).to receive(:print_student).exactly(selected_month_students.length).times
				end
			end
		end

		it 'prints the students' do
			students = [edward,anna,sarah]	
			expect_to_display(students)
			print_students_by_month students
		end
	end

	context 'when saving students to a file it' do

		it 'prepares students into CSV format' do
			student = anna
			expect(student_to_csv(student)).to eq ['anna', 'June']

		end

		it 'saves one student into a CSV file' do
			students = [edward]
			csv = double #this is a dummy file
			expect(csv).to receive(:<<).with(["Edward","November"])
			expect(CSV).to receive(:open).with('./student.csv','wb').and_yield(csv)
			save_students_to_file(students)
		end
		
		it 'saves many students list into a CSV file' do
			students = [edward,anna]
			csv = double #this is a dummy file	
			expect(csv).to receive(:<<).with(["Edward","November"])
			expect(csv).to receive(:<<).with(["anna","June"])
			expect(CSV).to receive(:open).with('./student.csv','wb').and_yield(csv)
			save_students_to_file(students)
		end
	end

	context 'when loading students from a file' do

		it 'adds the students from a csv file to student list' do
			students=[anna]
			csv = ['anna', 'June']
			expect(self).to receive(:create_student).with("anna","June")
			expect(CSV).to receive(:foreach).with("./student.csv").and_yield(csv)
			load_students_from_csv
			expect(students).to eq [{name: 'anna', cohort: :June}]
		end

	end

	context 'when at the main menu' do

		it 'welcomes the user and prints a menu' do
			expect(self).to receive(:show).with(
				"Please select an option:\n1. Input new students\n2. View students by cohort\n3. Save students to students.csv\n4. Load students from students.csv\n9. Exit\n")
			print_menu_options
		end

		it 'prints the students when user selects 1' do
			allow(self).to receive(:take_user_input).and_return("1")
			expect(self).to receive(:input_students)
			process_user_input
		end

		it 'does not prints the students when user selects 2' do
			allow(self).to receive(:take_user_input).and_return("1")
			expect(self).to receive(:input_students)
			process_user_input
		end

		it 'exits the program when user selects 5' do
			allow(self).to receive(:take_user_input).and_return("5")
			expect(self).to receive(:exit)
			process_user_input
		end
		
		it 'prints a message if innput not valid' do
			allow(self).to receive(:take_user_input).and_return("banana").exactly(1).times
			expect(self).to receive(:show).with("Sorry that is not a valid option")
			process_user_input
		end

	end 

 end


























