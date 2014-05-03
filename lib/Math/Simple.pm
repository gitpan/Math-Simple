#!/usr/bin/perl

=encoding utf-8

=head1 NAME

Math::Simple  -  Very simple, commonly used math routines

=head1 VERSION

Version "2.0.0"

=cut
our $VERSION='2.0.0';


{ package Math::Simple;
  BEGIN {
     require $_.".pm" && $_->import for qw(strict warnings);
  }
  use Xporter;

  our @EXPORT = qw(max min log10);
  our @EXPORT_OK = qw(log2 logb);

  {
    my @logs;
    sub logb($;$){
      die "logb requires 1 or  2 params" unless @_;
      if (@_==2) {
        return log($_[1]) / ($logs[$_[0]] ||= log $_[0]) }
      elsif ( @_==1) {
        my $base = $logs[$_[0]] ||= log $_[0];
        return sub ($) {
            log($_[0]) / $base;
          }
        }
    }
  }

  sub log2 ($)  { logb(2, $_[0]) }
  sub log10 ($) { logb(10, $_[0]) }
  sub max ($;@);
  sub min ($;@);

  sub max ($;@) { @_ == 2 and return  $_[0] >= $_[1] ? $_[0] : $_[1]; 
                  @_ == 1 and return $_[0];
                  max( max(pop @_, pop @_), @_); 
                }

  sub min ($;@) { @_ == 2 and return  $_[0] <= $_[1] ? $_[0] : $_[1]; 
                  @_ == 1 and return $_[0];
                  min( min(pop @_, pop @_), @_); 
                }
1}
###########################################################################
#             Pod documentation           {{{1
#    use Math::Simple

=head1 SYNOPSIS

 use Math::Simple qw(logb log2);
 my $low            =  min($a,$b, $c, $d ...);    # least positive num
 my $hi             =  max($a,$b);                # most positive num
 my $digits_ƒ       =  sub ($) {int log10($_[0]); # log10 default export  
 my $log_in_base    =  logb($base,$num);          # log arbitrary base
 my $log16_ƒ        =  logb(16);                  # create log16 func 
 my $bits_needed_ƒ  =  sub ($) {int log2($_[0])};
 use constant mbits => log2(~1);                  # compile constant

=head1 DESCRIPTION

Very simple math routines that I end up re-using in many progs and
libified for easy access.  

Currently five function, three exported by default.
Default exports are min(), max() and log10().
Optional exports are C<log2> and C<logb>.  Note on <logb>: it returns
a log in any base, with the base as the first param, and number as
the 2nd param, but given 1 parameter (the base), it will return a 
function ref that only returns that base.

Math::Simple uses Xporter, so including C<logb> or C<log2> doesn't break the
defaults import list see L<Xporter>.

=cut

