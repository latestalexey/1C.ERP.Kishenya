#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// При создании из поля ввода в наименовании отсутсвуют разделители
	Если Не ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Объект.Код) Тогда
		Объект.Код = Элементы.Код.ТекстРедактирования;
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповеститьОВыборе(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_КодУКТВЭД", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоКодУслугиИзДКПП(Код)
	
	Результат = Ложь;
	
	Если Найти(Код, ".") > 0 Тогда
		Результат = Истина;
	КонецЕсли; 
	
	Возврат Результат;

КонецФункции // ()

&НаКлиенте
Процедура СформироватьНаименование()

	Объект.Наименование = СокрЛП(Объект.Код) + ?(Объект.Вид = ПредопределенноеЗначение("Перечисление.ВидыКодовДляНалоговойНакладной.КодТовараИмпортированного")," X","") + 
		"/" + СтрЗаменить(Объект.НаименованиеПолное,Символы.ПС,"");

КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	СформироватьНаименование();
КонецПроцедуры

&НаКлиенте
Процедура ВидПриИзменении(Элемент)
	СформироватьНаименование();
КонецПроцедуры

&НаКлиенте
Процедура ВидОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Код) Тогда
		Если ((ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.ВидыКодовДляНалоговойНакладной.КодУслуги")) И НЕ ЭтоКодУслугиИзДКПП(Объект.Код)) ИЛИ
			 ((НЕ ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.ВидыКодовДляНалоговойНакладной.КодУслуги")) И ЭтоКодУслугиИзДКПП(Объект.Код)) Тогда
			 
			СтандартнаяОбработка = Ложь;				 
			ПоказатьПредупреждение(,НСтр("ru='Формат кода не соответствует выбранному виду кода!';uk='Формат коду не відповідає обраному виду коду!'"));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти