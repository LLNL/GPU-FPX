program main
  implicit none

  integer, parameter :: sz = 32768
  integer, dimension(sz) :: arr
  integer :: i

  do i = 1, sz
    arr(i) = 42
  end do

  !$omp target teams distribute parallel do map(tofrom: arr(1:sz))
  do i = 1, sz
    arr(i) = arr(i) + 1
  end do

  print *, "After the target region is executed, arr(1) = ", arr(1)

end program main
