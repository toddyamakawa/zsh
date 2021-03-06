#!/usr/bin/env ruby

input = ARGV.first
raise "Usage: #{$0} <number>" unless input

# Check if binary
if input[/^0b[01]+$/] then
	bases = [2]
# Check if hex
elsif input[/[a-fA-F]/] || input[/^0?x/] then
	bases = [16]
# Check if not binary
elsif input[/[2-9]/] then
	bases = [10, 16]
# Assume it's hex, bin, or dec
else
	bases = [10, 16, 2]
end

$GREEN = 32.freeze
$YELLOW = 33.freeze
$BLUE = 34.freeze

def num2all(int)
	alt_color = $BLUE
	hex = String.new
	bin = String.new
	int.to_s(16).split('').reverse.each_with_index do |nibble, i|
		color = (i/4%2 == 0) ? 0 : alt_color
		spacer = (i % 4 == 0) ? '_' : ''
		bits = nibble.to_i(16).to_s(2).rjust(4,'0')
		hex = nibble.color(color) + spacer + hex
		bin = bits.color(color) + "_#{bin}"
	end
	puts "#{"Hex".bold_color($YELLOW)}: #{hex.chomp('_')}"
	puts "#{"Bin".bold_color($YELLOW)}: #{bin.chomp('_')}"

	dec = String.new
	int.to_s(10).split('').reverse.each_with_index do |digit, i|
		color = (i/6%2 == 0) ? 0 : alt_color
		spacer = (i % 3 == 0) ? ',' : ''
		dec = digit.color(color) + spacer + dec
	end
	puts "#{"Dec".bold_color($YELLOW)}: #{dec.chomp(',')}"
end

class String
	def color(n); return "\e[#{n}m#{self}\e[0m"; end
	def bold_color(n); self.color("1;#{n}"); end
end

prefix = { 10 => '', 16 => "'h", 2 => "'b" }

bases.each do |base|
	puts "==> #{prefix[base]}#{input} <==".bold_color($GREEN)
	num2all(input.to_i(base))
end

