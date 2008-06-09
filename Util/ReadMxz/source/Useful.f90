module m_Useful
implicit none
private

  integer, parameter, public :: k_pr=kind(1.0d0) !< define precision for reals
  integer, parameter, public :: k_mw=40 !< number of character per word
  integer, parameter, public :: k_ml=255 !< number of character per line


!> data structure that contains the info about a frame
  type, private :: frameType
    character(len=k_mw) :: frameLabel
    real(k_pr) :: timestamp
    real(k_pr), allocatable, dimension(:) :: x,y,z,dx,dy,dz,q
    character(len=2), allocatable, dimension(:) :: element
    real(k_pr) :: tdx,tdy,tdz,dipole,charge,projDipole
  end type frameType

!> data structure that contains the info about frames and atoms
  type, public :: mxzType
    integer :: natoms=0 !< number of atoms in each frame
    integer :: nframes=0 !< number of frames in the file
    type(frameType),allocatable :: frames(:) !< contains the info about frames
  end type mxzType

  public :: error
  public :: GetUnit
contains

!> \brief Prints an error/warning message and aborts the programs if necessary
!> \author Alin M. Elena (Queen's University Belfast)
!> \date 14-15th January 2006
!> \param message the message that will be displayed
!> \param routine the name of the caller
!> \param uout integer  unit number for output
!> \param critical logical if true aborts the program
  subroutine error(message, routine, critical,uout)
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: routine
    logical, intent(in)   :: critical
    integer, intent(in) :: uout

    if (critical) then
      write(uout,*) &
        "Critical error in subroutine: ", routine
    else
      write(uout,*) &
        "Error message from subroutine: ", routine
    end if

    write(uout,*) routine,": ", message

    if (critical) then
      write(uout,*)routine,": User stop."
      write(*,*)routine," User stop."
      stop
    endif
  end subroutine error

!> \brief gives an integer that can be used as a unit number in a open command
!> \details this function should be used to avoid using the same unit in different open commands
!> \author Alin M Elena
!> \date 14-15th of January, 2006
!> \warning using a save attribute makes the function thread unsafe, however
!> I do not expect any problems from it (you do not open so many files after all)
  integer function GetUnit()
    character(len=*), parameter :: myname = 'GetUnit()'
    integer,save ::ustart=9

    ustart=ustart+1
    GetUnit=ustart

  end function GetUnit

end module m_Useful