@lists = []

def test_me
  "STUFF"
end

def main_menu
  list_counter = 0
  @lists.each do |list|
    list_counter += 1
    puts "#{list_counter}. #{list.title}\n"
  end
  puts "Press 'a' to add a new list.\nPress 'x' to exit the program."
  if @lists.length > 0
    puts "To view a list enter its cooresponding number."
  end
  @main_choice = gets.chomp
  if @main_choice == 'a'
    add_list
  elsif @main_choice == 'x'
    exit
  elsif @main_choice.to_i > 0 && @main_choice.to_i <= @lists.length
    task_menu
  else
    main_menu
  end
end

def task_menu
  @list_choice = @main_choice
  task_counter = 0
  puts @lists[@list_choice.to_i-1].title
  @lists[@list_choice.to_i-1].tasks.each do |task|
    task_counter += 1
    puts "#{task_counter}. #{task.description}\n"
  end
  puts "To select a task enter its cooresponding number.\nPress 'a' to add a new task to this list.\nPress 'd' to sort tasks by date.\nPress 'p' to sort tasks by priority.\nPress 'c' to view completed tasks.\nPress 'x' to return to the Main Menu"
  @task_choice = gets.chomp
  if @task_choice == 'd'
    @lists[@list_choice.to_i-1].sort_by_date
  elsif @task_choice == 'p'
    @lists[@list_choice.to_i-1].sort_by_priority
  elsif @task_choice == 'a'
    add_new_task
  elsif @task_choice == 'c'
    complete_counter = 0
    @lists[@list_choice.to_i-1].completed_tasks.each do |complete_task|
      puts "#{complete_counter}. #{complete_task.description}\n\n"
      puts "Press any key to return to list menu"
      if gets
        task_menu
      end
    end
  elsif @task_choice == 'x'
    main_menu
  elsif @task_choice.to_i <= @lists[@list_choice.to_i-1].tasks.length
    task_manager
  end
  task_menu
end

def task_manager
  puts "Press 'e' to edit the description.\nPress 'r' to mark as complete.\nPress 'p' to add a priority level.\nPress 'd' to add a due date.\nPress 'x' to return to main menu."
  task_manager_choice = gets.chomp
  if task_manager_choice == 'x'
    task_menu
  elsif task_manager_choice == 'e'
    puts "Enter a new task description."
    new_description = gets.chomp
    @lists[@list_choice.to_i-1].tasks[@task_choice.to_i-1].edit_task(new_description)
  elsif task_manager_choice == 'r'
    @lists[@list_choice.to_i-1].remove_task(@lists[@list_choice.to_i-1].tasks[@task_choice.to_i-1])
  elsif task_manager_choice == 'p'
    puts "Enter a priority level between 1-5."
    new_priority_level = gets.chomp
    @lists[@list_choice.to_i-1].tasks[@task_choice.to_i-1].add_priority(new_priority_level)
  elsif task_manager_choice == 'd'
    puts "Enter a due date in the form m/d."
    new_due_date = gets.chomp
    @lists[@list_choice.to_i-1].tasks[@task_choice.to_i-1].add_date(new_due_date)
  end
  task_manager
end

def add_list
  puts "Enter a title for your new list."
  list_title = gets.chomp
  @lists << List.new(list_title)
  puts "List added.\n\n"
  main_menu
end

def add_new_task
  puts "Enter the name of the task."
  task_title = gets.chomp
  @lists[@list_choice.to_i-1].add_task(Task.new(task_title))
  puts "#{@lists[@list_choice.to_i-1].tasks}"
  puts "Task added.\n\n"
end

main_menu
