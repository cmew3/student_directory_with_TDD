require 'date'

def show(string)
   puts string
end

def take_user_input
 	gets.chomp
end

def ask_for_data (info_needed)
	show("Please enter #{info_needed}.")
end


def is_cohort_valid?(string)
	Date::MONTHNAMES.compact.include?(string.downcase.capitalize)
end

def create_student(name, cohort)
	{name: name, cohort: cohort.downcase.capitalize.to_sym}
end

def students
	@students ||= []
end

def add_student_to_list(new_student)
	students << new_student
end


def get_input (data_type)
	if data_type=="cohort"
		user_input = ""
		until is_cohort_valid?(user_input)
			ask_for_data (data_type)
			user_input = take_user_input
		end
	else 
		ask_for_data (data_type)
		user_input = take_user_input
	end
	return user_input
end

def get_details_of_new_student
	name, cohort = get_inputs(["student's name", "cohort"])
	create_student(name, cohort)
	# puts "the students are ------ #{students}"
end


def get_inputs(input_list)
	input_list.map {|input_type| get_input(input_type)}
end

def print_student_number
	show ("There are #{students.length} student(s) in the directory")
end


def add_another_student?
	show('Would you like to add a new student ("Y") or finish ("N")')
	selection = take_user_input.upcase
 	process_user_choice(selection)
end

def process_user_choice selection
	case selection
	when "Y"
		new_student = get_details_of_new_student
		add_student_to_list(new_student)
		add_another_student?
	when "N"
		print_student_number
	else
		puts "try again"
		add_another_student?
	end
end

def print_student(student)
	show("#{student[:name].capitalize} is in the #{student[:cohort].capitalize} cohort")
end

def print_student_list(students)
	students.each do |student|
		print_student(student)
	end
end

def select_by_month(month, students)
	
	students.select{|student| student[:cohort]==month.to_sym}
end

def print_students_by_month students
	Date::MONTHNAMES.compact.each do |month|
		selected_month_students = select_by_month(month,students)
		if selected_month_students.length!=0
			puts month
			print_student_list(selected_month_students)
		end
	end
end


















