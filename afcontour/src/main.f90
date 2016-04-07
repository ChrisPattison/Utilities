program contour
use kinds
use geom
use csv_file
implicit none
    real(wp)::stagger,inangle,outangle,chord,solidity,a
    integer::points = 100, te2te = -1
    character(128)::infile,outfile
    integer,parameter::iunit=1,ounit=2
    type(camberline)::airfoil
    integer::i,err
    real(wp),dimension(:),allocatable::s
    real(wp),dimension(:,:),allocatable::camber,pressure,suction,normal
    namelist /Cascade/ stagger,inangle,outangle,chord,solidity,a
    namelist /Geometry/ points, te2te

    write(*,'(A)') 'Input file name:'
    read(*,'(A)') infile
    write(*,'(A)') 'Output file name:'
    read(*,'(A)') outfile
    open(iunit,file=infile)
    read(iunit,nml=Cascade)
    read(iunit,nml=Geometry,iostat=err)

    inangle = inangle * PI / 180.0_wp
    outangle = inangle * PI / 180.0_wp
    stagger = stagger * PI / 180.0_wp

    allocate(camber(2,points))
    allocate(pressure(2,points))
    allocate(suction(2,points))
    allocate(normal(2,points))
    allocate(s(points))

    airfoil = camberline(stagger,inangle,outangle,chord,solidity,a)
    !s = cos((/(PI/2/(size(s)-1)*i,i=0,size(s)-1)/))
    s = (/(1.0_wp/(size(s)-1)*i,i=0,size(s)-1)/)
    do i = 1, size(s)
        camber(:,i) = airfoil%point(s(i))
        normal(:,i) = airfoil%normal(s(i))
        pressure(:,i) = camber(:,i)-normal(:,i)*thickness_65010(airfoil, s(i))
        suction(:,i) = camber(:,i)+normal(:,i)*thickness_65010(airfoil, s(i))
    end do

    call clamp(camber)
    call clamp(pressure)
    call clamp(suction)
    open(ounit,file=outfile)
    call csv_write(ounit,camber)
    call csv_next_record(ounit)
    if(te2te>0) then
        call csv_write(ounit,pressure(:,::-1)) !TODO: Fix
        call csv_write(ounit,suction)
    else
        call csv_write(ounit,pressure)
        call csv_next_record(ounit)
        call csv_write(ounit,suction)
    endif

contains
subroutine clamp(a)
    real(wp),dimension(:,:)::a
    a = min(max(merge(a, 0.0_wp, abs(a)>1e-50_wp),-1.0e98_wp),1.0e98_wp)
end subroutine
end program contour