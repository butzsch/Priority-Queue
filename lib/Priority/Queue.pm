package Priority::Queue;
use warnings;
use strict;
use 5.024_000;

our $VERSION = '0.01';

sub new {
    my ($class, $self) = @_;

    $self->{elems} = [undef];
    $self->{compare} //= sub {return shift() < shift();};

    return bless($self, $class);
}

sub size {
    return shift->{elems}->$#*;
}

sub empty {
    return !shift->size();
}

sub top {
    return shift->{elems}->[1];
}

sub _compare_at {
    my ($self, $i, $j) = @_;

    return $self->{compare}->($self->{elems}->[$i], $self->{elems}->[$j]);
}

sub _swap_at {
    my ($self, $i, $j) = @_;

    my $tmp                 = $self->{elems}->[$i];
    $self->{elems}->[$i]    = $self->{elems}->[$j];
    $self->{elems}->[$j]    = $tmp;

    return;
}

sub _parent_node {
    my ($self, $c) = @_;
    return int($c / 2);
}

sub _bubble_up {
    my ($self) = @_;

    my $c      = $self->{elems}->$#*;
    my $p      = $self->_parent_node($c);

    while(($p > 0) && $self->_compare_at($c, $p)) {
        $self->_swap_at($c, $p);
        $c = $p;
        $p = $self->_parent_node($c);
    }

    return;
}

sub insert {
    my ($self, $e) = @_;

    push($self->{elems}->@*, $e);
    $self->_bubble_up();

    return;
}

sub _small_child {
    my ($self, $p) = @_;

    my $l_c = 2 * $p;
    my $r_c = 2 * $p + 1;

    my $max = $self->{elems}->$#*;

    if ($l_c > $max) {
        if($r_c > $max) {
            return;
        }
        return $r_c;
    }
    if($r_c > $max) {
        return $l_c;
    }

    return $self->_compare_at($l_c, $r_c) ? $l_c : $r_c;
}

sub _sink_down {
    my ($self) = @_;

    my $p = 1;
    my $s_c = $self->_small_child($p);

    while(defined($s_c) && $self->_compare_at($s_c, $p)) {
        $self->_swap_at($s_c, $p);
        $p = $s_c;
        $s_c = $self->_small_child($p);
    }

    return;
}

sub extract {
    my ($self) = @_;

    return if($self->empty());
    return pop($self->{elems}->@*) if($self->size() == 1);

    my $extr = $self->{elems}->[1];
    $self->{elems}->[1] = pop($self->{elems}->@*);
    $self->_sink_down();

    return $extr;
}

1;

__END__

=pod

=head1 NAME

Priority::Queue

=head1 DESCRIPTION

Einfaches Modul zum Erstellen einer Priorityqueue mit einstellbarer Vergleichsfunktion.

=head1 SYNOPSIS

# Instanziierung
my $q = Priority::Queue->new(
    {
        compare => sub {shift() > shift();},    # Vergleichsoperation
    },
);

# Neue Elemente hinzufügen
$q->insert(42);
$q->insert(13);
$q->insert(100);

# Anzahl der Elemente in der Queue
say $q->size();

# Element an der Spitze
say $q->top();

while(!$q->empty()) {
    # Entfernt Element an der Spitze und gibt es zurück
    say $q->extract();
}

=cut