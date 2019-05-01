#!/usr/bin/perl -w
# abinit roll installation test.  Usage:
# abinit.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '^(?!Frontend).';
my $output;
my $TESTFILE = 'tmpabinit';

# abinit-install.xml
if($appliance =~ /$installedOnAppliancesPattern/) {
  ok(-d "/opt/abinit", "abinit installed");
} else {
  ok(! -d "/opt/abinit", "abinit not installed");
}


# abinit
my $packageHome = '/opt/abinit';
my $testDir = "$packageHome/share/abinit-test/paral/Input";
SKIP: {

  skip 'abinit not installed', 1 if ! -d $packageHome;
  skip 'abinit test not installed', 1 if ! -d $testDir;
 `mkdir $TESTFILE.dir`;
 open(OUT, ">$TESTFILE.sh");
 print OUT <<END;
module load abinit \$1
cd $TESTFILE.dir
cp $packageHome/share/abinit-test/gpu/Input/t01.in .
cat <<ENDIT > t01.files
t01.in
t01.out
t01_Xi
t01_Xo
t01_Xx
$packageHome/share/abinit-test/Psps_for_tests/31ga.pspnc
$packageHome/share/abinit-test/Psps_for_tests/33as.pspnc
ENDIT
output=`mpirun -np 4 $packageHome/bin/abinit\$2 <t01.files 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  output=`mpirun --allow-run-as-root -np 4 $packageHome/bin/abinit\$2 <t01.files 2>&1`
fi
echo \$output
END
close(OUT);
  $output = `bash $TESTFILE.sh 2>&1`;
  $output=`cat $TESTFILE.dir/t01.out 2>&1`;
  ok($output =~ /etotal1    -1.070821.*E\Q+\E01/i, 'abinit sample run');
  SKIP: {
    skip 'CUDA_VISIBLE_DEVICES undef', 1
      if ! defined($ENV{'CUDA_VISIBLE_DEVICES'});
      $output2 = `bash $TESTFILE.sh CUDAVER .cuda 2>&1`;
      $output1 = `cat $TESTFILE.dir/t01.out 2>&1`;
      ok($output1 =~ /etotal1    -1.070821.*E\Q+\E01/i, 'abinit cuda sample run');
      ok($output2 =~ /Graphic Card Properties/, 'abinit cuda device detected');
  }
  `rm -rf $TESTFILE*`;
}


SKIP: {
    skip "abinit not installed", 3 if ! -d "/opt/abinit";
    my ($noVersion) = "abinit" =~ m#([^/]+)#;
    `/bin/ls /opt/modulefiles/applications/$noVersion/[0-9]* 2>&1`;
    ok($? == 0, "abinit module installed");
    `/bin/ls /opt/modulefiles/applications/$noVersion/.version.[0-9]* 2>&1`;
    ok($? == 0, "abinit version module installed");
    ok(-l "/opt/modulefiles/applications/$noVersion/.version",
       "abinit version module link created");
}
