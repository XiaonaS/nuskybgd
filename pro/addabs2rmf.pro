pro addabs2rmf,inrmf,ab,imref,regfile,bgddir,outrmf,$
      method=method,clobber=clobber,verbose=verbose

if size(outrmf,/type) eq 0 then begin
    print,'WARNING: RMF will be overwritten and will be INCOMPATIBLE for use'
    print,'         with nuproducts-generated ARFs that include detabs'
    print,'         (which it does by default)'
    if not keyword_set(clobber) then $
          stop,'ADDABS2RMF: nm, you did not set the clobber keyword'
    outrmf=inrmf
endif

if not file_test(bgddir,/directory) then $
      stop,'ADDABS2RMF: bgd directory does not exist'

det=fltarr(4)
detfrac=fltarr(4)
abs=fltarr(4096)
if not keyword_set(method) then method=1

runtype=size(imref,/type)
if runtype eq 7 then begin
    fits_read,imref,im
    reg=reg2mask(imref,regfile)
    for i=0,3 do begin
        file=bgddir+'/det'+str(i)+ab+'im.fits'
        if file_test(file) then fits_read,file,detim $
              else stop,'GETSPECRMF: Det image file '+file+' not found.'
        det[i]=total(im*reg*detim)
        detfrac[i]=total(reg*detim)
    endfor
    if method eq 1 then begin
        ii=where(det lt 0.01)
        if ii[0] ne -1 then det[ii]=0.
        ii=where(det ge 0.01)
        if ii[0] eq -1 then $
              stop,'ADDABS2RMF: Region does not overlap with any detectors'
    endif else begin
        ii=where(detfrac lt 0.01)
        if ii[0] ne -1 then detfrac[ii]=0.
        ii=where(detfrac ge 0.01)
        if ii[0] eq -1 then $
              stop,'ADDABS2RMF: Region does not overlap with any detectors'
    endelse
    det/=total(det)
    detfrac/=total(detfrac)
endif else if runtype eq 2 then begin
    i=imref
    det[i]=1.0
    detfrac[i]=1.0
    ii=where(det ge 0.01)
    if ii[0] eq -1 then $
          stop,'ADDABS2RMF: Region does not overlap with any detectors'
endif else stop,'ADDABS2RMF: 3rd argument '+str(imref)+' of wrong type'

not1=''
not2=''
if method eq 1 then not2=' not' else not1=' not'

if keyword_set(verbose) then begin
    print,'Det  weight(image-weighted,'+not1+' used)  '+ $
          'flat (area-weighted,'+not2+' used)'
    for i=0,3 do print,i,det[i],detfrac[i],format='(I3,F18.2,F30.2)'
endif

if method eq 2 then det=detfrac

for i=0,n_elements(ii)-1 do begin
    absstr=mrdfits(getcaldbfile('detabs',ab,ii[i]),ii[i]+1,dh,/silent)
    abs+=absstr.detabs*det[ii[i]]
endfor

; read in inrmf, multiply by abs, and write to outrmf
rmf1=mrdfits(inrmf,1,h1,/silent)
rmf2=mrdfits(inrmf,2,h2,/silent)
ii=where(tag_names(rmf1) eq 'MATRIX')
if ii[0] ne -1 then begin
    extnum=1
    matrix=rmf1.matrix
endif
ii=where(tag_names(rmf2) eq 'MATRIX')
if ii[0] ne -1 then begin
    extnum=2
    matrix=rmf2.matrix
endif
if size(matrix,/type) eq 0 then stop,'ADDABS2RMF: matrix extension in rmf not found'

for e=0,4095 do matrix[*,e]=matrix[*,e]*abs[e]
if extnum eq 1 then rmf1.matrix=matrix else rmf2.matrix=matrix
mwrfits,rmf1,outrmf,h1,/silent,/create
mwrfits,rmf2,outrmf,h2,/silent

end
