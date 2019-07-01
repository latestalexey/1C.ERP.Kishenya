////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись в модели сервиса".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает сохраняемое значение пароля для указанного пароля.
//
// Параметры:
//  Пароль                      - Строка - пароль для которого нужно получить сохраняемое значение.
//
//  ИдентификаторПользователяИБ - УникальныйИдентификатор - пользователя ИБ для которого нужно
//                                сравнить сохраняемое значение с полученным и результат поместить
//                                в следующий параметр Совпадает.
//
//  Совпадает                   - Булево (возвращаемое значение) - см. комментарий к параметру
//                                ИдентификаторПользователяИБ.
// Возвращаемое значение:
//  Строка - сохраняемое значение пароля.
//
Функция СохраняемоеЗначениеСтрокиПароля(Знач Пароль,
                                        Знач ИдентификаторПользователяИБ = Неопределено,
                                        Совпадает = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СохраняемоеЗначениеПароля = ПолучитьСохраняемоеЗначениеСтрокиПароля(Пароль);
	
	Если ТипЗнч(ИдентификаторПользователяИБ) = Тип("УникальныйИдентификатор") Тогда
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
			ИдентификаторПользователяИБ);
		
		Если ТипЗнч(ПользовательИБ) = Тип("ПользовательИнформационнойБазы") Тогда
			Совпадает = (СохраняемоеЗначениеПароля = ПользовательИБ.СохраняемоеЗначениеПароля);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СохраняемоеЗначениеПароля;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСохраняемоеЗначениеСтрокиПароля(Пароль)
	
	Если ЗначениеЗаполнено(Пароль) Тогда
		Хеширование = Новый ХешированиеДанных(ХешФункция.SHA1);
		Хеширование.Добавить(СокрЛП(Пароль));
		ХешПароля1 = Base64Строка(Хеширование.ХешСумма);
		
		Хеширование = Новый ХешированиеДанных(ХешФункция.SHA1);
		Хеширование.Добавить(ВРег(СокрЛП(Пароль)));
		ХешПароля2 = Base64Строка(Хеширование.ХешСумма);
		
		Возврат ХешПароля1 + "," + ХешПароля2;	
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

#КонецОбласти