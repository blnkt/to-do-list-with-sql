require 'pg'
require './lib/task.rb'
require './lib/list.rb'
require 'pry'

DB = PG.connect({:dbname => 'to_do'})

def main_menu
  puts "Enter 'a' to add a new list.\nEnter 'l' to list active lists\nEnter 'x' to exit the program."
  # if @lists.length > 0
  #   puts "To view a list enter its cooresponding number."
  # end
  main_choice = gets.chomp
  if main_choice == 'a'
    add_list
  elsif main_choice == 'l'
    show_lists
  elsif main_choice == 'x'
    exit
  else
    main_menu
  end
end

def add_list
  puts "Enter a name for your new list."
  list_name = gets.chomp.to_s
  new_list = List.new({"name" => list_name})
  new_list.save
  puts "List added.\n\n"
  main_menu
end

# def add_new_task
#   puts "Enter the name of the task."
#   task_name = gets.chomp
#   new_task = Task.new(task_name)
#   puts "Task added.\n\n"
# end

def show_lists
  lists = List.all
  lists.each do |list|
    puts "#{list.id}:  #{list.name}"
  end
  puts "Enter list_id to view/edit your list."
  id = gets.chomp
  system("clear")
  puts "#{List.find(id).name}\n"
  puts "

end

 main_menu
