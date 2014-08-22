require 'bundler/setup'
Bundler.require(:default)
I18n.enforce_available_locales = false

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['development'])

def welcome
  system('clear')
  puts "*" * 27
  puts "Welcome to Chamber Players!"
  puts "*" * 27
  main_menu
end

def main_menu
  puts "\nPlease select from the following choices:"
  puts "[p] to add a new piece"
  puts "[m] to add a new musician"
  puts "[x] to exit"

  choice = gets.chomp
  case choice
  when 'p'
    add_piece
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

  new_piece = Piece.create(title: title, composer: composer, number_of_parts: number_of_parts)

  if new_piece.save
    puts "\n#{new_piece.title} by #{new_piece.composer} has been added to the music library."
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
    new_piece.errors.full_messages.each { |message| puts message }
    add_piece
  end
end

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
