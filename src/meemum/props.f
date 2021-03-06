      module props

        use, intrinsic :: iso_c_binding
        use, intrinsic :: iso_fortran_env

        implicit none

        ! global variables
        include "perplex_parameters.h"

      contains

        !> @return n_soln_models Number of solution models
        function n_soln_models() bind(c)
          integer(c_size_t) :: n_soln_models

          integer isoct
          common / cst79 / isoct

          n_soln_models = isoct
        end function

        !> @param  soln_id        Solution model index
        !! @return abbr_soln_name Abbreviated solution model name
        function abbr_soln_name(soln_id) bind(c)
          integer(c_size_t), intent(in), value :: soln_id
          type(c_ptr) :: abbr_soln_name

          character fname*10, aname*6, lname*22
          common / csta7 / fname(h9), aname(h9), lname(h9)

          abbr_soln_name = alloc_c_str(aname(soln_id))
        end function

        !> @param  soln_id        Solution model index
        !! @return full_soln_name Full solution model name
        function full_soln_name(soln_id) bind(c)
          integer(c_size_t), intent(in), value :: soln_id
          type(c_ptr) :: full_soln_name

          character fname*10, aname*6, lname*22
          common / csta7 / fname(h9), aname(h9), lname(h9)

          full_soln_name = alloc_c_str(fname(soln_id))
        end function

        !> @return n_phases Number of phases
        function n_phases() bind(c)
          integer(c_size_t) :: n_phases

          integer kkp, np, ncpd, ntot
          double precision cp3, amt
          common / cxt15 / cp3(k0,k19), amt(k19), kkp(k19), 
     >    np, ncpd, ntot

          n_phases = ntot
        end function

        !> @param  phase_id   Phase index
        !! @return phase_name Phase name
        function phase_name(phase_id) bind(c)
          integer(c_size_t), intent(in), value :: phase_id
          type(c_ptr) :: phase_name

          character pname*14
          common / cxt21a / pname(k5)

          phase_name = alloc_c_str(pname(phase_id))
        end function

        !> @param  phase_id          Phase index
        !! @return phase_weight_frac Fractional phase weight
        function phase_weight_frac(phase_id) bind(c)
          integer(c_size_t), intent(in), value :: phase_id
          real(c_double) :: phase_weight_frac

        double precision props, psys, psys1, pgeo, pgeo1
        common / cxt22 / props(i8,k5), psys(i8), psys1(i8),
     >  pgeo(i8),pgeo1(i8)
          ! source: olib.f
          phase_weight_frac = props(17, phase_id) * props(16, phase_id) 
     >    / psys(17)
        end function

        !> @param  phase_id       Phase index
        !! @return phase_vol_frac Fractional volume of a phase
        function phase_vol_frac(phase_id) bind(c)
          integer(c_size_t), intent(in), value :: phase_id
          real(c_double) :: phase_vol_frac

          double precision props, psys, psys1, pgeo, pgeo1
          common / cxt22 / props(i8,k5), psys(i8), psys1(i8),
     >    pgeo(i8),pgeo1(i8)

          ! source: olib.f
          phase_vol_frac = props(1, phase_id) * props(16, phase_id) 
     >    / psys(1)
        end function

        !> @param  phase_id       Phase index
        !! @return phase_mol_frac Fractional number of moles of a phase
        function phase_mol_frac(phase_id) bind(c)
          integer(c_size_t), intent(in), value :: phase_id
          real(c_double) :: phase_mol_frac

          double precision props, psys, psys1, pgeo, pgeo1
          common / cxt22 / props(i8,k5), psys(i8), psys1(i8),
     >    pgeo(i8),pgeo1(i8)

          ! source: olib.f
          phase_mol_frac = props(16, phase_id) / psys(16)
        end function

        !> @param  phase_id  Phase index
        !! @return phase_mol Number of moles of a phase
        function phase_mol(phase_id) bind(c)
          integer(c_size_t), intent(in), value :: phase_id
          real(c_double) :: phase_mol

          double precision props, psys, psys1, pgeo, pgeo1
          common / cxt22 / props(i8,k5), psys(i8), psys1(i8),
     >    pgeo(i8),pgeo1(i8)

          ! source: olib.f
          phase_mol = props(16, phase_id)
        end function

        !> @return sys_density The system density (kg/m3)
        function sys_density() bind(c)
          real(c_double) :: sys_density

          double precision props, psys, psys1, pgeo, pgeo1
          common / cxt22 / props(i8,k5), psys(i8), psys1(i8),
     >    pgeo(i8),pgeo1(i8)
          
          ! source: olib.f
          sys_density = psys(10)
        end function

        !> @return sys_expansivity The system expansivity
        function sys_expansivity() bind(c) 
          real(c_double) :: sys_expansivity

          double precision props, psys, psys1, pgeo, pgeo1
          common / cxt22 / props(i8,k5), psys(i8), psys1(i8),
     >    pgeo(i8),pgeo1(i8)

          ! source: olib.f
          sys_expansivity = psys(13)
        end function

        !> @return sys_mol_entropy The system molar entropy
        function sys_mol_entropy() bind(c)
          real(c_double) :: sys_mol_entropy

          double precision props, psys, psys1, pgeo, pgeo1
          common / cxt22 / props(i8,k5), psys(i8), psys1(i8),
     >    pgeo(i8),pgeo1(i8)

          ! source: olib.f
          sys_mol_entropy = psys(15)
        end function

        !> @return sys_mol_heat_capacity The system molar heat capacity
        function sys_mol_heat_capacity() bind(c)
          real(c_double) :: sys_mol_heat_capacity

          double precision props, psys, psys1, pgeo, pgeo1
          common / cxt22 / props(i8,k5), psys(i8), psys1(i8),
     >    pgeo(i8),pgeo1(i8)

          ! source: olib.f
          sys_mol_heat_capacity = psys(12) / psys(1) * 1d5 / psys(10)
        end function

        !> Convert a Fortran string to a C string.
        !! @param f_str The Fortran string to be converted.
        !! @return ptr The location of the allocated C string in memory.
        function alloc_c_str(f_str) result(ptr)
          character(len=*), intent(in) :: f_str
          type(c_ptr) :: ptr

          character(c_char), dimension(:), pointer :: c_str

          ! allocate memory for C string
          allocate(c_str(len_trim(f_str)+1))

          ! copy across Fortran string
          c_str = transfer(trim(f_str) // c_null_char, c_str)

          ! return pointer to C string
          ptr = c_loc(c_str)
        end function
      end module
       
!       !UNUSED
!       function get_melt_frac() bind(c) result(melt_frac)
!         real(c_double) :: melt_frac
!         double precision props,psys,psys1,pgeo,pgeo1
!         common/ cxt22 /props(i8,k5),psys(i8),psys1(i8),pgeo(i8),
!    >    pgeo1(i8)

!         ! melt_frac = props(17,imelt)*props(16,imelt) / psys(17)
!         melt_frac = 0.1
!       end function


!       function has_melt() bind(c)
!         logical(c_bool) :: has_melt

!         logical gflu,aflu,fluid,shear,lflu,volume,rxn
!         common/ cxt20 /gflu,aflu,fluid(k5),shear,lflu,volume,rxn

!         has_melt = aflu
!       end function

!       function is_melt(phase_id) bind(c)
!         integer(c_int), intent(in) :: phase_id
!         logical(c_bool) :: is_melt

!         logical gflu,aflu,fluid,shear,lflu,volume,rxn
!         common / cxt20 / gflu, aflu, fluid(k5), shear, lflu, volume,
!    >    rxn

!         is_melt = fluid(phase_id)
!       end function

!       function get_n_components() bind(c) result(n)
!         integer(c_int) :: n

!         n = k5
!       end function

!       subroutine get_component_name(comp_id, comp_name) bind(c)
!         integer(c_int), intent(in) :: comp_id
!         character(c_char), dimension(*), intent(out) :: comp_name

!         ! component names (from where?)
!         character*5 cname
!         common / csta4 / cname(k5)

!         integer :: i

!         do i = 1, 5
!         comp_name(i:i) = cname(comp_id)(i:i)
!         end do
!       end subroutine

!       subroutine get_component_amount(comp_id, comp_amount) bind(c)
!         integer(c_int), intent(in) :: comp_id
!         real(c_double), intent(out) :: comp_amount

!         integer :: i

!         ! where is this from? file reference
!         double precision a,b,c
!         common / cst313 / a(k5,k1), b(k5), c(k1)

!         comp_amount = b(comp_id)
!       end subroutine
