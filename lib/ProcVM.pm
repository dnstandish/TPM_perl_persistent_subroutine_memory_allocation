
package ProcVM;

use autodie;


sub print_proc_vm {

    open my $fd, '<', "/proc/$$/status";
    while ( <$fd> ) {
        print if /^Vm/;
    }
    close $fd;
    
}
 
1;
