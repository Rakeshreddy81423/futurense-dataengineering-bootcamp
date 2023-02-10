 -- create database healthcare;

use healthcare;


-- person 
alter table person add constraint `FK_person_address` foreign key(addressid) references address(addressid);

-- patient
alter table patient add constraint `FK_patient_person` foreign key(patientid) references person(personid);

-- insurancecompany
alter table insurancecompany add constraint `FK_insurancecompany_address` foreign key(addressid) references address(addressid);

-- insuranceplan
alter table insuranceplan add constraint `FK_insuranceplan_insurancecompany` foreign key(companyid) references insurancecompany(companyid);

-- claim
alter table claim add constraint `FK_claim_insuranceplan` foreign key(uin) references insuranceplan(uin);

-- treatment
alter table treatment add constraint `FK_treatment_claim` foreign key(claimid) references claim(claimid);
alter table treatment add constraint `FK_treatment_disease` foreign key(diseaseid) references disease(diseaseid);
alter table treatment add constraint `FK_treatment_patient` foreign key(patientid) references patient(patientid);


-- prescription
alter table prescription add constraint `FK_prescription_treatment` foreign key(treatmentid) references treatment(treatmentid);
alter table prescription add constraint `FK_prescription_pharmacy` foreign key(pharmacyid) references pharmacy(pharmacyid);

-- contain
alter table contain add constraint `FK_contain_prescription` foreign key(prescriptionid) references prescription(prescriptionid);
alter table contain add constraint `FK_contain_medicine` foreign key(medicineid) references medicine(medicineid);

-- pharmacy 
alter table pharmacy add constraint `FK_pharmacy_address` foreign key(addressid) references address(addressid);

-- keep
alter table keep add constraint `FK_keep_pharmacy` foreign key(pharmacyid) references pharmacy(pharmacyid);
alter table keep add constraint `FK_keep_medicine` foreign key(medicineid) references medicine(medicineid);




