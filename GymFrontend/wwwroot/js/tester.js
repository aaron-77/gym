import { formatFecha, generateTitleXAxis, makeDataLabelXAxis,assembleQueryParams} from './seccionGraficacionControl.js';
console.log(generateTitleXAxis([1,3],'individual','mes',null,null));
console.log(generateTitleXAxis([1,11],'individual','mes',null,null));
console.log(formatFecha("2025-07-14T00:00:00"));
console.log(makeDataLabelXAxis('2025-07-14T00:00:00',1));
console.log(makeDataLabelXAxis('2025-07-21T00:00:00',2));
console.log(makeDataLabelXAxis('2025-07-28T00:00:00',3));
console.log(makeDataLabelXAxis('2025-08-04T00:00:00',4));
console.log(assembleQueryParams("años",[2024,2025],"meses",[1,2,3]));