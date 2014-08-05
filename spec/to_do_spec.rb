require 'rspec'
require 'task'
require 'pg'
require 'list'
require 'pry'

DB = PG.connect({:dbname => 'to_do_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM tasks *;")
  end
end

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM lists *;")
  end
end

describe 'Task' do
   it 'is initialized with a name and a list ID' do
    task = Task.new({"name"=>'learn SQL',"list_id" => 1, "date" => '2014-08-07'})
    task.should be_an_instance_of Task
  end

  it 'tells you its name' do
    task = Task.new({"name"=>'learn SQL',"list_id" => 1, "date" => '2014-08-07'})
    task.name.should eq 'learn SQL'
  end

  it 'tells you its list ID' do
    task = Task.new({"name"=>'learn SQL',"list_id" => 1, "date" => '2014-08-07'})
    task.list_id.should eq 1
  end

  it 'starts off with no tasks' do
    Task.all.should eq []
  end

  it 'lets you save tasks to the database' do
    task = Task.new({"name"=>'learn SQL',"list_id" => 1, "date" => "2014-10-10"})
    task.save
    Task.all.should eq [task]
  end


  describe ".delete" do
    it 'lets you delete a task' do
      task = Task.new({"name"=>'learn SQL',"list_id" => 1, "date" => '2014-08-07'})
      task.save
      Task.delete('learn SQL')
      expect(Task.all).to eq []
    end
  end

  it 'is the same task if it has the same name and ID' do
    task1 = Task.new({"name"=>'learn SQL',"list_id" => 1, "date" => '2014-08-07'})
    task2 = Task.new({"name"=>'learn SQL',"list_id" => 1, "date" => '2014-08-07'})
    task1.should eq task2
  end

  describe '.all' do
    it "starts off with no tasks" do
      expect(Task.all).to eq []
    end
  end

  describe '.find' do
    it 'retrieves all tasks from its list_id' do
      a_task = Task.new({"name"=>'learn SQL',"list_id" => 2, "date" => '2014-08-07'})
      a_task.save
      expect(Task.find(2)).to eq [a_task]
    end
  end

  describe '.mark' do
    it 'lets you mark a task as completed' do
      task = Task.new({"name"=>'learn SQL',"list_id" => 1, "date" => '2014-08-07'})
      task.save
      Task.mark('learn SQL')
      expect(Task.marked(1)[0].completed).to eq 't'
    end

    it 'lets you mark a task as completed' do
      task = Task.new({"name"=>'learn SQL',"list_id" => 1, "date" => '2014-08-07'})
      task2 = Task.new({"name"=>'learn SQB',"list_id" => 1, "date" => '2014-08-07'})
      task.save
      task2.save
      Task.mark('learn SQL')
      expect(Task.marked(1).length).to eq 1
      expect(Task.unmarked(1).length).to eq 1
    end
  end

  describe '.unmarked' do
    it 'returns unmarked tasks ordered by date' do
      task = Task.new({"name"=>'learn SQL',"list_id" => 1, "date" => '2014-08-07'})
      task.save
      task_one = Task.new({"name"=>'learn SQL',"list_id" => 1, 'date' => '2014-08-10'})
      task_one.save
      task_two = Task.new({"name"=>'learn SQL',"list_id" => 1, 'date' => '2014-08-09'})
      task_two.save
      expect(Task.unmarked(1)).to eq [task, task_two, task_one]
    end
  end
end

describe List do
  it 'is initialized with a name' do
    list = List.new({"name" =>'Epicodus stuff'})
    list.should be_an_instance_of List
  end

  it 'tells you its name' do
    list = List.new({"name" =>'Epicodus stuff'})
    list.name.should eq 'Epicodus stuff'
  end

  it 'is the same list if it has the same name' do
    list1 = List.new({"name" =>'Epicodus stuff'})
    list2 = List.new({"name" =>'Epicodus stuff'})
    list1.should eq list2
  end

  it 'sets its id when you save it' do
    list1 = List.new({"name" =>'Epicodus stuff'})
    list1.save
    expect(list1.id).to be_an_instance_of Fixnum
  end

  it 'can be initialized with its database ID' do
    list = List.new({"name" =>'Epicodus stuff', "id" => 1})
    list.should be_an_instance_of List
  end

  describe '.all' do
    it 'returns all lists' do
      list = List.new ({"name" =>'Epicodus stuff'})
      list2 = List.new ({"name" =>'Curry stuff'})
      list.save
      list2.save
      expect(List.all).to eq [list, list2]
    end
  end

  describe '.find' do
    it 'retrieves a list from its id' do
      list = List.new ({"name" =>'Epicodus stuff'})
      list_id = list.save
      expect(List.find(list_id)).to eq list
    end
  end

  describe '.delete' do
    it 'deletes a list and all associated tasks' do
      krazy_list = List.new({"name" => 'Heeeeeeeeeey'})
      list_id = krazy_list.save
      k_task = Task.new({"name" => 'quite it!', "list_id" => list_id, "date" => '2014-08-07'})
      k_task.save
      List.delete(list_id)
      expect(List.all).to eq []
      expect(Task.all).to eq []
    end
  end

end
