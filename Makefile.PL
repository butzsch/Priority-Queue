#!/usr/bin/env perl
use warnings;
use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME 			=> 'Priority::Queue',
	VERSION_FROM 	=> 'lib/Priority/Queue.pm',
);