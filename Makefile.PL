require 5.005_62;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'Class::MethodMaker::Util',
    VERSION_FROM => 'lib/Class/MethodMaker/Util.pm',
    PREREQ_PM    => {
        Class::MethodMaker => 1.06,
    },
);
