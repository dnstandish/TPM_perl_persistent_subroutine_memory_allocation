
SCRIPTS=scripts
GEN=generated
TEMPLATE=templates
PERL_VER := $(shell perl -e 'print $$^V')

simple=mem_test1.pl  mem_test2.pl  mem_test3.pl  mem_test4.pl  mem_test5.pl  mem_test6.pl  mem_test7.pl mem_test8.pl mem_test9.pl
simple_base := $(basename $(simple))
simple_err := $(addprefix $(PERL_VER)/, $(addsuffix .err,  $(simple_base)))


all: setup simple_tests memuse_tests memlimit
	@/bin/echo $(PERL_VER)
	@/bin/echo "$(simple_err)"

setup: $(PERL_VER) bin compare generated


$(PERL_VER):
	mkdir  $(PERL_VER)

bin compare generated:
	mkdir $@


simple_tests:$(simple_err)
	@echo $< $@

memuse_tests: $(PERL_VER)/func1.eps $(PERL_VER)/func1_c2.eps $(PERL_VER)/func1_cu.eps $(PERL_VER)/func1_effect_const.eps $(PERL_VER)/func1_effect_1const.eps $(PERL_VER)/func1_local.eps  $(PERL_VER)/func4.eps  $(PERL_VER)/func6.eps  $(PERL_VER)/recur1.eps  $(PERL_VER)/recur2.eps  $(PERL_VER)/recur3.eps $(PERL_VER)/func1var.eps $(PERL_VER)/mem_test10.eps  $(PERL_VER)/mem_test10undef.eps  $(PERL_VER)/func1_return.eps 

memlimit: $(PERL_VER)/func1_memlimit.out

vpath %.pl ../scripts
#vpath %.err $PERL_VER
#VPATH=../scripts

#$PERL_VER/%.err:%.pl
#v5.18.2/%.err:scripts/%.pl
$(PERL_VER)/%.err:scripts/%.pl
	$< >$@ 2>&1  
#	echo $<
#	echo $@

bin/setrlimit: src/setrlimit.c
	gcc -o $@ $<


$(GEN)/func1.pl:$(TEMPLATE)/many_func1.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000  -out $@  -r 1 -temp $(TEMPLATE)/many_func1.template 

$(GEN)/func1_c2.pl:$(TEMPLATE)/many_func1.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000  -out $@  -r 2 -temp $(TEMPLATE)/many_func1.template 

$(GEN)/func1_cu.pl:$(TEMPLATE)/many_func1.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000  -out $@  -cu -temp $(TEMPLATE)/many_func1.template 

$(GEN)/func1const.pl:$(TEMPLATE)/many_func1const.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000  -out $@ -temp $(TEMPLATE)/many_func1const.template 

$(GEN)/func1const_cu.pl:$(TEMPLATE)/many_func1const.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000  -out $@  -cu -temp $(TEMPLATE)/many_func1const.template 

$(GEN)/func1_1const_cu.pl:$(TEMPLATE)/many_func1_1const.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000 -cu  -out $@ -temp $(TEMPLATE)/many_func1_1const.template


$(GEN)/func1_local.pl:$(TEMPLATE)/many_func1_local.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000  -out $@  -r 1 -temp $(TEMPLATE)/many_func1_local.template 

$(GEN)/func4.pl:$(TEMPLATE)/many_func4.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000  -out $@  -r 1  -temp $(TEMPLATE)/many_func4.template  

$(GEN)/func6.pl:$(TEMPLATE)/many_func6.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000  -out $@  -r 1  -temp $(TEMPLATE)/many_func6.template  

$(GEN)/func1var.pl:$(TEMPLATE)/many_func1var.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000 -r 3 -out $@ -temp $(TEMPLATE)/many_func1var.template 

$(GEN)/func1_return.pl:$(TEMPLATE)/many_func1_return.template  $(SCRIPTS)/gen_test_template.pl
	$(SCRIPTS)/gen_test_template.pl -nf 20 -s 800000  -out $@  -r 1 -temp $(TEMPLATE)/many_func1_return.template 


$(GEN)/recur1.pl: $(SCRIPTS)/recur1.pl
	cp $< $@

$(GEN)/recur2.pl: $(SCRIPTS)/recur2.pl
	cp $< $@

$(GEN)/recur3.pl: $(SCRIPTS)/recur3.pl
	cp $< $@

$(GEN)/mem_test10.pl: $(SCRIPTS)/mem_test10.pl
	cp $< $@

$(GEN)/mem_test10undef.pl: $(SCRIPTS)/mem_test10undef.pl
	cp $< $@

$(PERL_VER)/%.out: $(GEN)/%.pl
	$< > $@

$(PERL_VER)/func1_memlimit.out $(PERL_VER)/func1_memlimit.err : $(GEN)/func1.pl bin/setrlimit
	-bin/setrlimit 16000000 $(GEN)/func1.pl > $(PERL_VER)/func1_memlimit.out 2> $(PERL_VER)/func1_memlimit.err

$(PERL_VER)/func1.eps: $(PERL_VER)/func1.out
	$(SCRIPTS)/parse_result.pl -title '20 calls vanilla' -out $@ $<

$(PERL_VER)/func1_c2.eps: $(PERL_VER)/func1_c2.out
	$(SCRIPTS)/parse_result.pl -vm VmData -cycle 2 -title '20 calls vanilla, 2 cycles' -out $@ $<

$(PERL_VER)/func1_cu.eps: $(PERL_VER)/func1.out $(PERL_VER)/func1_cu.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title '20 calls vanilla vs call undef' -out $@  $(PERL_VER)/func1.out $(PERL_VER)/func1_cu.out

$(PERL_VER)/func1_effect_const.eps:  $(PERL_VER)/func1.out $(PERL_VER)/func1_cu.out $(PERL_VER)/func1const.out $(PERL_VER)/func1const_cu.out
	$(SCRIPTS)/parse_result.pl -title '20 calls vanilla vs nonconst vs const'  -vm VmData -out $@ $(PERL_VER)/func1.out $(PERL_VER)/func1_cu.out $(PERL_VER)/func1const.out $(PERL_VER)/func1const_cu.out

$(PERL_VER)/func1_effect_1const.eps: $(PERL_VER)/func1.out $(PERL_VER)/func1_cu.out $(PERL_VER)/func1const.out  $(PERL_VER)/func1const_cu.out $(PERL_VER)/func1_1const_cu.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title  '20 calls vanilla vs nonconst vs 1 const' -out $@  $(PERL_VER)/func1.out $(PERL_VER)/func1_cu.out $(PERL_VER)/func1const.out  $(PERL_VER)/func1const_cu.out $(PERL_VER)/func1_1const_cu.out

$(PERL_VER)/func1_local.eps: $(PERL_VER)/func1.out $(PERL_VER)/func1_local.out $(PERL_VER)/func1const_cu.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title '20 calls local vs lexical w constant' -out $@ $(PERL_VER)/func1.out $(PERL_VER)/func1_local.out $(PERL_VER)/func1_1const_cu.out

$(PERL_VER)/func4.eps: $(PERL_VER)/func1.out $(PERL_VER)/func4.out $(PERL_VER)/func1const_cu.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title 'closure vs lexical' -out $@ $(PERL_VER)/func1.out $(PERL_VER)/func1_1const_cu.out $(PERL_VER)/func4.out

$(PERL_VER)/func6.eps: $(PERL_VER)/func1.out $(PERL_VER)/func4.out $(PERL_VER)/func1const_cu.out $(PERL_VER)/func6.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title 'closure vs lexical' -out $@ $(PERL_VER)/func1.out $(PERL_VER)/func1_1const_cu.out $(PERL_VER)/func4.out $(PERL_VER)/func6.out

$(PERL_VER)/recur1.eps: $(PERL_VER)/recur1.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title 'recursion' -out $@ $(PERL_VER)/recur1.out

$(PERL_VER)/recur2.eps: $(PERL_VER)/recur2.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title 'recursion 2' -out $@ $(PERL_VER)/recur2.out

$(PERL_VER)/recur3.eps: $(PERL_VER)/recur3.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title 'recursion 3' -out $@ $(PERL_VER)/recur3.out


$(PERL_VER)/func1var.eps: $(PERL_VER)/func1var.out
	$(SCRIPTS)/parse_result.pl -vm VmData -cycle 3 -title '20 calls variable size 3 cycles' -out $@ $(PERL_VER)/func1var.out

$(PERL_VER)/mem_test10.eps: $(PERL_VER)/mem_test10.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title 'Allocate vs Deallocate' -out $@ $(PERL_VER)/mem_test10.out

$(PERL_VER)/mem_test10undef.eps: $(PERL_VER)/mem_test10.out $(PERL_VER)/mem_test10undef.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title 'Allocate vs Deallocatewith undef' -out $@ $(PERL_VER)/mem_test10.out $(PERL_VER)/mem_test10undef.out

$(PERL_VER)/func1_return.eps: $(PERL_VER)/func1.out $(PERL_VER)/func1_return.out
	$(SCRIPTS)/parse_result.pl -vm VmData -title '20 calls returning value' -out $@ $(PERL_VER)/func1.out  $(PERL_VER)/func1_return.out

compare/mem_test10.eps: v5.18.2/mem_test10.eps v5.28.1/mem_test10.eps
	$(SCRIPTS)/parse_result.pl -vm VmData -title 'Allocate vs Deallocate' -out $@ v5.18.2/mem_test10.out v5.28.1/mem_test10.out

