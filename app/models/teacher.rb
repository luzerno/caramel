class Teacher < User

  authenticates_with_sorcery!

  has_many :assignments
  has_many :programs, :through => :assignments, :dependent => :restrict_with_exception
  has_many :schools, -> {uniq}, :through => :programs
  has_many :enrollments, :through => :programs
  has_many :students, -> {uniq}, :through => :enrollments

  def program_ids
    programs.map do |program|
      program.id
    end
  end

  def programs_json
    programs.map do |program|
      {:id => program.id, :text => program.name}
    end
  end

  def programs_in_school(school_id)
    programs.where(:school_id => school_id)
  end

  def programs_in_school_json(school_id)
    programs_in_school(school_id).map do |program|
      {:id => program.id, :text => program.name}
    end
  end

  def self.in_regions_ordered(region_ids)
    User.in_regions_ordered('Teacher', region_ids)
  end

  def self.all_ordered
    User.all_ordered('Teacher')
  end

  def schools_ordered
    schools = []
    programs.each do |program|
      schools.push(School.find(program.school_id))
    end
    schools.uniq.sort_by{|school| school.name}
  end

  def schools_ordered_json
    schools_ordered.map do |school|
      {:id => school.id, :text => school.name}
    end
  end

  def students_ordered
    students = Student.in_programs(program_ids)
    schools_ordered.each do |school|
      students += school.students_unenrolled
    end
    students.sort_by {|student| student.first_name}
  end

  def students_in_one_school_ordered(school_id)
    program_ids = []
    programs.each do |program|
      if program.school_id == school_id
        program_ids.push(program.id)
      end
    end
    students = Student.in_programs(program_ids)
    students += School.find(school_id).students_unenrolled
  end

  def students_in_one_school_ordered_json(school_id)
    students_in_one_school_ordered(school_id).map do |student|
      {:id => student.id, :text => student.name}
    end
  end

  def students_ordered_json
    students_ordered.map do |student|
      {:id => student.id, :text => student.name}
    end
  end

  def programs_in_one_region(region_id)
    result = []
    programs.each do |program|
      if program.school.region_id.to_i == region_id.to_i
        result.push(program)
      end
    end
    result
  end

  def program_ids_in_one_region(region_id)
    programs_in_one_region(region_id).map do |program|
      program.id
    end
  end

  def locked_region_ids
    result = []
    regions.each do |region|
      if programs_in_one_region(region.id).any?
        result.push(region.id)
      end
    end
    result
  end

  def schools_in_one_region(region_id)
    result = []
    schools_ordered.each do |school|
      if school.region_id.to_i == region_id.to_i
        result.push(school)
      end
    end
    result
  end

  def remove_program(program_id)
    Assignment.destroy(Assignment.where(:teacher_id => id, :program_id => program_id))
  end

  def add_program(program_id)
    Assignment.create(program_id: program_id, teacher_id: id)
  end

end
