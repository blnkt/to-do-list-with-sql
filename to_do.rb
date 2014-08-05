require 'pg'
require './lib/task.rb'
require './lib/list.rb'
require 'pry'

DB = PG.connect({:dbname => 'to_do'})

def main_menu
  system('clear')
  puts "Enter 'a' to add a new list.\nEnter 'l' to list active lists\nEnter 'x' to exit the program."
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

def add_task id
  puts "Enter the name of the task."
  task_name = gets.chomp
  new_task = Task.new({"name" => task_name, "list_id" => id})
  new_task.save
  puts "Task added.\n\n"
end

def show_lists
  system('clear')
  lists = List.all
  lists.each do |list|
    puts "#{list.id}:  #{list.name}"
  end
  puts "Enter list_id to view/edit a list.\nEnter 'd' to delete a list.\n Enter x to return to Main Menu"
  id = gets.chomp
  if id == 'd'
    puts "Enter the list_id to delete the list"
    list_id = gets.chomp
    List.delete(list_id)
    show_lists
  elsif id.to_i > 0
    target_list id
  else
    main_menu
  end
end

def target_list id
  system("clear")
  puts "#{List.find(id).name.upcase}\n\n"
  puts "UNCOMPLETED TASKS:"
  puts "-----"
  uncompleted_tasks = Task.unmarked(id)
  binding.pry
  uncompleted_tasks.each_with_index do |task, index|
    puts "#{index}: #{task.name}"
  end
  puts "\n\nCOMPLETED TASKS"
  puts "-----"
  completed_tasks = Task.marked(id)
  completed_tasks.each_with_index do |task, index|
    puts "#{index}: #{task.name}"
  end
  puts "Enter 'a' to add a task to this list.\nEnter 'd' to delete a task.\nEnter 'x' to return to the main menu.\n"
  input = gets.chomp
  case input
  when 'a'
    add_task id
  when 'd'
    puts "enter a number to delete the cooresponding task."
    num = gets.chomp.to_i
    task_name = tasks[num].name
    Task.delete(task_name)
  when 'x'
    main_menu
  end
  target_list id
end

 main_menu
