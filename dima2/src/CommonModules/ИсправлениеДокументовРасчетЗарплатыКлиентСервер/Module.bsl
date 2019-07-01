////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА ОСТАТКИ ОТПУСКОВ
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает доступны ли перерасчеты для переданной формы.
// Форма должна содержать реквизиты объекта.
//
Функция ПерерасчетыДоступны(Форма, ИмяРеквизитаПериодаРегистрации = "ПериодРегистрации", ИмяРеквизитаДатыНачала = "ДатаНачала", ВозможноВытеснение = Истина) Экспорт
	
	Возврат ЗначениеЗаполнено(Форма.Объект.ИсправленныйДокумент)
		Или (ВозможноВытеснение И (Форма.Объект[ИмяРеквизитаПериодаРегистрации] > Форма.Объект[ИмяРеквизитаДатыНачала] И ЗначениеЗаполнено(Форма.Объект[ИмяРеквизитаДатыНачала])))
		Или (Форма.Объект.НачисленияПерерасчет.Количество() > 0);
	
КонецФункции

#КонецОбласти
