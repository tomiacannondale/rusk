# Rusk

Rusk is library that read and write Open Document Spreadsheet Format(ods).

## Installation

Add this line to your application's Gemfile:

    gem 'rusk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rusk

## Usage

### Open file ###

Read with block.

```ruby
	Rusk::Book.open('path_to_odsfile') do |book|
	  # do something
	end
```

Read without block.

```ruby
	book = Rusk::Book.open('path_to_odsfile')
	book.close
```

Rusk::Book.open can't create new file.

### Save file ###

```ruby
	Rusk::Book.open('path_to_odsfile') do |book|
	  # do something
	  book.save
	end
```

### access sheet ###

Rusk::Sheet object can access with Rusk::Book#[] method.

Rusk::Book#[] can access with sheet name or index.

```ruby
	sheet = book[0]
```

or

```ruby
	sheet = book["Sheet1"]
```

### access cell ###

### read cell ###

Rusk::Cell object can access with Rusk::Sheet#[] and Rusk::Sheet#each and Rusk::Sheet#each_row.

Rusk::Sheet#[]

```ruby
	cell = Rusk::Sheet[0, 0]   # get Rusk::Cell at [A1]
```

Rusk::Sheet#each

```ruby
	sheet.each do |cell|
	  # do something (cell is Rusk::Cell)
	end
```

Rusk::Sheet#each_row

```ruby
	sheet.each_row do |row|
	  # do something (row is Array of Rusk::Cell elements)
	end
```

Rusk::Sheet#each_column

```ruby
    sheet.each_column do |column|
	  # do something (column is Array of Rusk::Cell elements)
	end
```

#### cell's value ####

Rusk::Cell#value gets the value of the cell according to the format.

```ruby
	# when cell's value is string
	cell.value  # => "Matz"
	# when cell's value is float
	cell.value  # => 1.0
	# when cell's value is date
	cell.value  # => #<Date: 2012-01-01 ((2455928j,0s,0n),+0s,2299161j)>
	# when cell's value is enter date of time
	cell.value # => #<DateTime: 2012-01-01T00:00:00+00:00 ((2455928j,0s,0n),+0s,2299161j)>
	# when cell's value is time
	cell.value # => "12:30" (string not time)
	# when cell's value is percentage(maybe application(example LibreOffice, OpenOffice) show '10%')
	cell.value  # => 0.1
	# when cell's value is boolean
	cell.value # => ture or false
```

### modify cell ###

To set value to cell, use Rusk::Cell#value=.

```ruby
	cell.value = "string" # => set "string" to cell and set string to value-type
	cell.value = 1.0      # => set 1.0(float) to cell and set float to value-type
	cell.value = Date.new(2012,4,29)   # => set cell 2012-04-29 to cell and set date to value-type
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Support ##

Report issues and feature requests to [github Issues](https://github.com/tomiacannondale/rusk/issues).

## Author ##

[tomi](mailto:tomiacannondale@gmail.com)

## License ##

MIT License. For more imformation, please see LICENSE.
