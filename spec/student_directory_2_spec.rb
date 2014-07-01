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
	     	allow(self).to receive(:ask_for_data)
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
	 	it 'does not ask for a new student when user selests "N"' do
	 		allow(self).to receive(:take_user_input).and_return("N")
	 		expect(self).not_to receive(:get_details_of_new_student)
	 		add_another_student?
	 	end

	 	it 'keeps asking for new students while user enters "Y"' do
	 		allow(self).to receive(:take_user_input).and_return("Y", "Sarah", "June", "Y", "Edward", "may", "N")
	 		allow(add_another_student?)
	 		expect(students.count).to eq 2
	 	end

	 	it 'counts the number of students when the array is empty and user selects "N"' do
	 		allow(self).to receive(:take_user_input).and_return("N")
	 		expect(self).to receive(:print_student_number).and_return("There are 0 students(s) in the directory") 
	 		add_another_student?
	 	end

	 	it 'counts the number of students when the array is not empty when pressed "N"' do 
	     	add_student_to_list(sarah)
	     	add_student_to_list(edward)
	     	allow(self).to receive(:take_user_input).and_return("N")
	 		expect(self).to receive(:print_student_number).and_return("There are 2 students(s) in the directory") 
	 		add_another_student?
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
	end

	context 'when asked to sort' do

		it 'lists the november students only' do
			students = [edward,anna,sarah]
			expect(select_by_month("November",students)).to eq([edward])
		end

		it 'lists the june students only' do
			students = [edward,anna,sarah]
			expect(select_by_month("June",students)).to eq([anna,sarah])
		end

		xit 'prints all the june students only' do
			students = [edward,anna,sarah]
			Date::MONTHNAMES.compact.each do |month|
				expect(self).to receive(:select_by_month)
			end
			print_students_by_month(students)
		end
	end

 end




























