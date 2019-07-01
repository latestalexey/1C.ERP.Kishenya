
#Область ПрограммныйИнтерфейс

// Процедура предназначена для заполнения значений показателей, 
// которые не удалось выявить по источникам данных подсистемы «Расчет зарплаты».
//
// Параметры:
//	ДополнительныеПоказатели - таблица значений с колонками:
//		Сотрудник
//		Подразделение
//		ДатаНачала
//		ДатаОкончания
//		Начисление
//		ВремяВЧасах
//		Показатель
//		Значение
//		КомандаРасшифровки - строка, если заполнена отображается в табличной части 
//								под значением показателя.
//		ЗначениеОпределено - булево, признак того, что значение выявлено.
//
Процедура ЗаполнитьЗначенияДополнительныхПоказателей(ДополнительныеПоказатели) Экспорт
	
КонецПроцедуры

// Процедура предназначена для заполнения значений показателей в строке данных формы.
//
// Параметры:
//		ВидРасчетаИнфо - Информация о виде расчета, полученная с помощью метода
//		                 ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета.
//		СтрокаНачислений - строка таблицы "Начисления".
//		ДанныеПоказателей - Таблица показателей.
//		РежимРаботы - режим работы таблицы с видами расчетов
//			0 - режим ввода штатного расписания - вводятся максимальные 
//				и минимальные значения ("вилка") условно-постоянных показателей
//			1 - режим ввода плановых начислений - вводятся значения 
//				условно-постоянных показателей
//			2 - режим ввода начислений в документе-начислятеле - вводятся значения всех 
//				показателей, отображаемых при виде расчета.
//		ОтображатьТекущиеЗначения - признак того, что в форме отображаются действующие на настоящий 
//			момент показатели начислений. Применяется, например, в документах кадровых переводов.
//			По умолчанию - Ложь
//
Процедура ПоместитьДанныеДополнительныхПоказателейВСтрокуТаблицыВидовРасчета(ВидРасчетаИнфо, СтрокаНачислений, ДанныеПоказателей, РежимРаботы, ОтображатьТекущиеЗначения = Ложь) Экспорт
	
КонецПроцедуры

// Предназначен для сбора дат, которые подсистема «Расчет зарплаты» использует 
// для разделения строк начислений на отдельные периоды.
// Необходимо выполнить запрос, создающий временную таблицу с полями:
//	- Сотрудник, 
//	- Начисление,
//	- Период - дата изменения условий начисления, 
//		в результате строка с указанным начислением будет разделена на две по указанной дате.
// Имя созданной временной таблицы следует добавить в массив ИменаВТ.
//
// Параметры:
//	- МенеджерВременныхТаблиц - менеджер таблиц, 
//		содержит таблицу ВТНачисленияСотрудников с полями.
//			Сотрудник, 
//			Начисление
//	- Начало - дата начала периода, за который получаются данные для начисления.
//	- Окончание - дата окончания периода.
//	- ИменаВТ - массив строк с именами добавляемых в менеджер временных таблиц.
//
Процедура СоздатьВТПериодыИзмененияОтдельныхНачислений(МенеджерВременныхТаблиц, Начало, Окончание, ИменаВТ) Экспорт
	
КонецПроцедуры

// Процедура предназначена для определения алгоритмов расчета результата предопределенным способом.
//
// Параметры:
//	- СпособРасчета - ПеречислениеСсылка.СпособыРасчетаНачислений, ПеречислениеСсылка.СпособыРасчетаУдержаний,
//	- СтрокиРасчета - массив строк таблицы значений данных для расчета с колонками:
//			- ЗаписьРасчета - строка набора записей регистра расчета.
//			- ИсходныеДанные - структура с значениями показателями, используемыми в контексте расчета.
//	- НаборыЗаписей - структура наборов записей, моделирующая коллекцию движений документа 
//			с установленным отбором по временному регистратору.
//	- ДокументСсылка - ссылка на документ, выполняющий расчет.
//
Процедура РассчитатьПредопределеннымСпособом(СпособРасчета, СтрокиРасчета, НаборыЗаписей, ДокументСсылка) Экспорт
	
КонецПроцедуры

// Заполнение сведений о показателях, используемых при расчете результата предопределенным способом.
//
// Параметры:
//	- ТаблицаПоказателей - таблица значений с колонками
//		СпособРасчета.
//		Показатель
//
Процедура ЗаполнитьПоказателиРасчетаПредопределеннымСпособом(ТаблицаПоказателей) Экспорт
	
КонецПроцедуры

#КонецОбласти
