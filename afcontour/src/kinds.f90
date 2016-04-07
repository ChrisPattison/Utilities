module kinds
    !! Module to manage kinds for the program
    implicit none
    private
    
    !==============!
    != Real Kinds =!
    !==============!
    
    integer,parameter::sp = selected_real_kind(6)
        !! Single precision
    integer,parameter::dp = selected_real_kind(15)
        !! Double precision
    integer,parameter::ep = selected_real_kind(18)
        !! Extended precision
    integer,parameter::qp = selected_real_kind(32)
        !! Quad precision
    integer,parameter::wp = dp
        !! Set working precision
    
    !==================!
    != Math Constants =!
    !==================!
    
    real(wp),parameter::PI  = 4.0_wp*atan(1.0_wp)
        !! Archimedes' constant
    real(wp),parameter::E   = exp(1.0_wp)
        !! Euler's constant
    
    !===========!
    != Exports =!
    !===========!
    
    public::wp
    public::PI,E
end module kinds
 
