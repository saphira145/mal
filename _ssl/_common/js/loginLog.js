function actionSubmit() {
    document.form_search.st.value = "ls";
    document.form_search.submit();
    document.form_search.st.value = "";

    return false;
}


function actionCsvSubmit() {
    document.form_csv.st.value = "csv";
    document.form_csv.submit();
    document.form_csv.st.value = "";

    return false;
}

function actionDetailSubmit($date, $logType){
    document.form_detail.st.value = "dtl";
    document.form_detail.logType.value = $logType;
    document.form_detail.date.value = $date;
    document.form_detail.submit();
    document.form_detail.st.value = "";
    document.form_detail.logType.value = "";
    document.form_detail.date.value = "";

    return false;
}


