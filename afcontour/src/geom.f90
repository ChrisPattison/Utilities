module geom
use kinds
implicit none

type::camberline
    real(wp)::stagger !stagger angle
    real(wp)::inlet   !inlet angle relative to chord line
    real(wp)::outlet  !outlet angle relative to chord line
    real(wp)::chord   !chord
    real(wp)::solidity!blade row solidity (c/s)
    real(wp)::ac      !ratio of maximum camber to chord line
contains
    procedure::coeff => parabola_coeff
    procedure::point => camber_point
    procedure::normal => camber_normal
end type

type::coeff_parabola
    real(wp)::a
    real(wp)::b
    real(wp)::c
end type

contains
    
function parabola_coeff(line) result(coeff)
    class(camberline),intent(in)::line
    type(coeff_parabola)::coeff
    real(wp)::theta

    theta  = line%inlet + line%outlet
    coeff%c = line%chord
    coeff%a = line%ac*line%chord
    coeff%b = line%chord * (sqrt(1.0_wp+(4.0_wp*tan(theta))**2* &
        (line%ac-(line%ac)**2-3.0_wp/16.0_wp))-1.0_wp)/(4.0_wp*tan(theta))
end function

function camber_trans(line, xy) result(v)
    class(camberline),intent(in)::line
    real(wp),dimension(2),intent(in)::xy
    real(wp),dimension(2)::v
    real(wp),dimension(2,2)::rotation
    rotation = reshape([cos(line%stagger),sin(line%stagger),&
        -sin(line%stagger),cos(line%stagger)],[2,2])
    v = matmul(rotation,xy)
end function

function parabola_point(line, s) result(xy)
    class(camberline),intent(in)::line
    real(wp),intent(in)::s
    real(wp),dimension(2)::xy
    real(wp)::yold
    type(coeff_parabola)::p
    real(wp),parameter::resid=1e-5

    p = line%coeff()
        
    xy(1) = s*line%chord
    xy(2) = 0.0_wp
    yold  = 1.0_wp

    do while (abs((xy(2)-yold)) > resid)
        yold = xy(2)
        xy(2) = xy(1)*(p%c-xy(1))/&
            ((p%c-2.0_wp*p%a)**2/(4.0_wp*p%b**2)*xy(2)+&
                (p%c-2.0_wp*p%a)/p%b*xy(1)-&
                (p%c**2-4.0_wp*p%a*p%c)/(4.0_wp*p%b))
    end do
end function

function camber_point(line, s) result(xy)
    class(camberline),intent(in)::line
    real(wp),intent(in)::s
    real(wp),dimension(2)::xy

    xy = camber_trans(line, parabola_point(line,s))
end function

function camber_normal(line, s) result(N)
    class(camberline),intent(in)::line
    real(wp),intent(in)::s
    real(wp),dimension(2)::N,xy
    real(wp)::m
    type(coeff_parabola)::p

    xy = line%point(s)
    p = line%coeff()

    m = 4.0_wp*p%b*(2.0_wp*p%b*xy(1)-(2.0_wp*p%a-p%c)*xy(2)-p%b*p%c)/&
        (4.0_wp*(2.0_wp*p%a-p%c)*p%b*xy(1)-2.0_wp*(2.0_wp*p%a-p%c)**2.0*xy(2)-&
            (4.0_wp*p%a-p%c)*p%b*p%c)
    m = -1.0_wp/m
    N = [-1.0_wp/sqrt(m**2+1.0_wp),-m/sqrt(m**2+1.0_wp)]
    N = merge(N, -N, N(2) > 0)
    N = camber_trans(line, N)
end function

function thickness_65010(line, s) result(t)
    class(camberline),intent(in)::line
    real(wp),intent(in)::s
    real(wp)::t,sc
    sc = s/line%chord
    t = line%chord*(1.493648_wp*sc**5 - 3.859133_wp*sc**4 + &
        3.733238_wp*sc**3 - 1.831468_wp*sc**2 + 4.650193E-01_wp*sc)
end function
end module geom