require 'bundler/setup'
Bundler.require(:default)
I18n.enforce_available_locales = false

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['development'])

@current_composer = nil
@current_piece = nil

def welcome
  system('clear')
  puts "*" * 27
  puts "Welcome to Chamber Players!"
  puts "*" * 27
  main_menu
end

def main_menu
  puts "\nPlease select from the following choices:"
  puts "[c] to add a new chamber piece"
  puts "[p] to list and add parts of a piece"
  puts "[m] to add a new musician"
  puts "[x] to exit"

  choice = gets.chomp
  case choice
  when 'c'
    add_piece
  when 'p'
    parts
  when 'm'
    add_musician
  when 'x'
    puts "\nUntil next time!"
    exit
  else
    puts "\nInvalid option, please try again."
    main_menu
  end
end

def add_piece
  puts "\nPlease enter the title of the piece:"
  title = gets.chomp

  puts "\nPlease enter the composer of the piece:"
  composer = gets.chomp

  puts "\nPlease enter the number of parts for this piece:"
  number_of_parts = gets.chomp

  new_composer = Composer.create(:name composer)
  new_piece = Piece.create(title: title, composer: new_composer.id, number_of_parts: number_of_parts)

  if new_piece.save && new_composer.save
    puts "\n#{new_piece.title} by #{new_composer.name} has been added to the music library."
    puts "\nWould you like to enter a new piece? y/n"
    choice = gets.chomp
    case choice
    when 'y'
      add_piece
    when 'n'
      puts "\nReturning to the main menu..."
      main_menu
    else
      puts "\nInvalid entry, returning to the main menu."
      main_menu
    end
  else
    puts "\nSorry, that wasn't a valid entry. Please try again."
    if !new_piece
      new_piece.errors.full_messages.each { |message| puts message }
    elsif !new_composer
      new_composer.errors.full_messages.each { |message| puts message }
    end
    add_piece
  end
end

def parts
  puts "\nPlease enter a name of a composer, to help locate a piece."
  composer = gets.chomp
  @current_composer = Composer.where(:name == composer.capitalize)

  # do a scope
  # puts "\nHere are all of our pieces composed by #{@current_composer.name}:"
  # results.each_with_index do |piece, index|
  #   puts "#{index+1}. #{piece.title} -- #{piece.number_of_parts} parts."
  # end

  puts "\nWhich one would you like to access? Please enter the appropriate number, or [x] to return to the main menu."
  choice = gets.chomp

  if choice == 'x'
    puts "\nReturning to the main menu..."
    main_menu
  elsif choice.to_i == 0
    puts "\nInvalid entry, please try again."
    parts
  else
    @current_piece = Piece.all.fetch((choice.to_i)-1) do |piece|
      puts "\n#{choice} isn't a valid option, please try again."
    end
  end
  list_parts
end

# def list_parts
  # if @current_piece.parts.length == 0
  #   puts "\nLooks like there are no parts listed for this piece yet. Let's add some!"
  #   add_parts
  # else @current_piece.parts.length > 0
  #   list_parts
  # end
#   puts "\nHere are the parts listed for #{@current_piece.name}:"
#   @current_piece.parts.each_with_index do |part|
#     puts "#{index+1}"
#   end
#   #menu 1. add parts, 2. assign musicians
# end

def add_musician
  puts "\nPlease enter the name of the musician:"
  name = gets.chomp

  puts "\nPlease enter this musician's main instrument:"
  instrument = gets.chomp

  new_musician = Musician.create(name: name, instrument: instrument)

  if new_musician.save
    puts "\n#{new_musician.name} (#{new_musician.instrument} player) has been added to the personnel list."
    puts "\nWould you like to enter a new musician? y/n"
    choice = gets.chomp
    case choice
    when 'y'
      add_musician
    when 'n'
      puts "\nReturning to the main menu..."
      main_menu
    else
      puts "\nInvalid entry, returning to the main menu."
      main_menu
    end
  else
    puts "\nSorry, that wasn't a valid entry. Please try again."
    new_piece.errors.full_messages.each { |message| puts message }
    add_musician
  end
end

welcome
