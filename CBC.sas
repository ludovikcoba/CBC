libname sasuser "/home/lucoba0/sasusr";

/*In order to run the following code the MktEx macros should be installed first*/
/*Link to the macros: https://support.sas.com/techsup/technote/mr2010.zip*/

title 'Design 3 x 3';

%mktruns(3 3)

%mktex(3 3, n = 9)

proc print data=design;run;

%choiceff(data=design, /* candidate set of alternatives */
model=class(x1-x2 / sta), /* model with stdzd orthogonal coding, we will use "effects" to switch to effects codins*/
nsets=6, /* number of choice sets */
seed=127, /* random number seed */
maxiter=100,
flags=3, /* 3 alternatives */
options=relative, /* display relative D-efficiency */
beta=zero) /* assumed beta vector, Ho: b=0 */

proc print; by set; id set; run;


proc print data=bestcov label;
id __label;
label __label = '00'x;
run;

%mktdups(generic, data=best, nalts = 3, factors=x1-x2)


title 'Evaluating results';
/*
 *The responses should be stored in a table where the columns are: 
 * - Respondent id 
 * - choice set id, varies from 1 to 6, since our design has 6 choice sets.
 * - selected choice, 1 if selected, 2 if not 
 * - active level
 */

data results;
	input Subj set c x1 x2 x3 x4 x5 x6;
	Set = 6;
	datalines;
1 1 2 0 1 0 0 0 1 
1 1 1 1 0 0 1 0 0 
1 1 2 0 0 1 0 1 0 
1 2 2 1 0 0 0 0 1 
1 2 1 0 0 1 0 1 0 
1 2 2 0 1 0 1 0 0 
1 3 2 0 0 1 1 0 0 
1 3 1 0 1 0 0 1 0 
1 3 2 1 0 0 0 0 1 
1 4 2 1 0 0 0 1 0 
1 4 1 0 0 1 1 0 0 
1 4 2 0 1 0 0 0 1 
1 5 2 0 1 0 1 0 0 
1 5 2 1 0 0 0 1 0 
1 5 1 0 0 1 0 0 1 
1 6 1 0 1 0 0 1 0 
1 6 2 0 0 1 0 0 1 
1 6 2 1 0 0 1 0 0 
102 1 2 0 1 0 0 0 1 
102 1 1 1 0 0 1 0 0 
102 1 2 0 0 1 0 1 0 
102 2 2 1 0 0 0 0 1 
102 2 2 0 0 1 0 1 0 
102 2 1 0 1 0 1 0 0 
102 3 1 0 0 1 1 0 0 
102 3 2 0 1 0 0 1 0 
102 3 2 1 0 0 0 0 1 
102 4 2 1 0 0 0 1 0 
102 4 1 0 0 1 1 0 0 
102 4 2 0 1 0 0 0 1 
102 5 1 0 1 0 1 0 0 
102 5 2 1 0 0 0 1 0 
102 5 2 0 0 1 0 0 1 
102 6 2 0 1 0 0 1 0 
102 6 2 0 0 1 0 0 1 
102 6 1 1 0 0 1 0 0 
;
/*
 * Th data in this example is randomly generated.
 */


proc phreg data=results outest=betas;
	strata subj set;
	model c*c(2) = x1-x6 / ties=breslow;
	label x1 = 'nr Rating: high' x2 = 'nr Rating: mid' x3 = 'nr Rating: small' x4 = 'Mean: big' x5 = 'Mean: mid' x6 = 'Mean: small';
run;


