////////////////////////////////////////////////////////////////////////////////
//  Методы, связанные с записью на сервере результатов замеров времени выполнения 
//  ключевых операций и их дальнейшем экспортом.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Функция записи массива замеров 
//
// Параметры:
//  Замеры - Массив элементов типа Структура.
//
// Возвращаемое значение:
// 	Число - текущее значение периода записи замеров на сервере в секундах в случае записи замеров.
//
Функция ЗафиксироватьДлительностьКлючевыхОпераций(АдресХранилища) Экспорт
	
	Если МонопольныйРежим() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Замеры = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Для Каждого КлючеваяОперацияЗамер Из Замеры Цикл
			КлючеваяОперацияСсылка = КлючеваяОперацияЗамер.Ключ;
			Буфер = КлючеваяОперацияЗамер.Значение;
			Для Каждого ДатаДанные Из Буфер Цикл
				Данные = ДатаДанные.Значение;
				Длительность = Данные.Получить("Длительность");
				Если Длительность = Неопределено Тогда
					// Неоконченный замер, писать его пока рано
					Продолжить;
				КонецЕсли;
				ОценкаПроизводительности.ЗафиксироватьДлительностьКлючевойОперации(
					КлючеваяОперацияСсылка,
					Длительность,
					Данные["ДатаНачала"],
					Данные["ДатаОкончания"],
					Данные["Комментарий"],
					Данные["Технологический"]);
			КонецЦикла;
		КонецЦикла;
		
	Возврат ПериодЗаписи();
	
КонецФункции

// Текущее значение периода записи результатов замеров на сервере
//
// Возвращаемое значение:
// Число - значение в секундах. 
Функция ПериодЗаписи() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущийПериод = Константы.ОценкаПроизводительностиПериодЗаписи.Получить();
	
	Возврат ?(ТекущийПериод >= 1, ТекущийПериод, 60);
	
КонецФункции

// Текущая дата на сервере
//
// Возвращаемое значение:
// 	Число - текущая универсальная дата в миллисекундах.
Функция ДатаИВремяНаСервере() Экспорт
	Возврат Дата(1,1,1) + ТекущаяУниверсальнаяДатаВМиллисекундах()/1000;
КонецФункции

#КонецОбласти