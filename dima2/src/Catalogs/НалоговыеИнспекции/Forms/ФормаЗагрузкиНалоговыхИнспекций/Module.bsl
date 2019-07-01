
&НаКлиенте
Процедура Загрузить(Команда)
	//ОбработатьРезультатыПодбораНаСервере();
	ЗагрузитьДанныеОНалоговыхИнспекциях();
	ОповеститьОбИзменении(Тип("СправочникСсылка.НалоговыеИнспекции"));	
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ФайлДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = НСтр("ru='Выберите xml файл с данными о налоговых инспекциях';uk='Виберіть xml файл із даними про податкові інспекції'");
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Фильтр = НСтр("ru='Файл данных (*.xml)|*.xml|Архивный файл данных (*.aml)|*.aml';uk='Файл даних (*.xml)|*.xml|Архивний файл даних (*.aml)|*.aml'");
	Диалог.Расширение = "xml";
	
	Диалог.ПолноеИмяФайла = ДанныеВыбора;

	Если Диалог.Выбрать() Тогда
		ФайлДанных = Диалог.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеОНалоговыхИнспекциях()
	
	ФайлСписокГНИ = Новый Файл(ФайлДанных);

	Если не ФайлСписокГНИ.Существует() Тогда
		Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Файл %1 не найден!""';uk='Файл %1 не знайдений!""'"), ФайлДанных));
		фОшибка = 1;
		Возврат;
	КонецЕсли;
	
	СпрНИ = Справочники.НалоговыеИнспекции;
	
	фОшибка = 0;
	Попытка
		xmlDoc = Новый COMОбъект("Msxml2.DOMDocument.4.0");
	Исключение
		Попытка
			xmlDoc = Новый COMОбъект("Msxml2.DOMDocument.3.0");
		Исключение
			фОшибка = 1;
			
		 Возврат;
		КонецПопытки;
	КонецПопытки;
 	
   xmlDoc.load(ФайлДанных);

   root = xmlDoc.documentElement;
   rootChild = root.childNodes;
   КвоОбработано = 0;

   Для Инд1 = 0 по rootChild.length - 1 Цикл
   	    УзелУр2 = rootChild.item(Инд1);
		УзелУр2Child = УзелУр2.childNodes;
		КодРегиона = "";
		ИмяРегиона = "";
		Для Инд2 = 0 по УзелУр2Child.length - 1 Цикл
			// УзелУр3 - это реквизиты регионов
			УзелУр3 = УзелУр2Child.item(Инд2);
			
			Если Врег(УзелУр3.baseName) = ВРег("C_REG") Тогда
				КодРегиона = УзелУр3.text;
				Если СтрДлина(КодРегиона) = 1 Тогда
					//дополним до 2 символов
					КодРегиона = "0"+КодРегиона;
				КонецЕсли;
			ИначеЕсли Врег(УзелУр3.baseName) = ВРег("NAME_REG") Тогда
				ИмяРегиона = УзелУр3.text;
				//Состояние(НСтр("ru='Загружается область: ';uk='Завантажується область: '") + ИмяРегиона);
			ИначеЕсли Врег(УзелУр3.baseName) = ВРег("SET_STI") Тогда
				// список налоговых
				// создадим (или найдем) группу - регион для записи подчиненных
				 НайденнаяСсылка = СпрНИ.НайтиПоКоду(КодРегиона);
				 Если (НайденнаяСсылка = СпрНИ.ПустаяСсылка()) Тогда
					НоваяГруппа = СпрНИ.СоздатьГруппу() ;
					НоваяГруппа.Наименование = ИмяРегиона;
					НоваяГруппа.Код = КодРегиона;
					НоваяГруппа.Записать();
					Родитель = НоваяГруппа.Ссылка;
				ИначеЕсли НеОбновлять = 0 Тогда
					ОбъектДляЗаписи = НайденнаяСсылка.ПолучитьОбъект(); 
					ОбъектДляЗаписи.Наименование = ИмяРегиона;
					ОбъектДляЗаписи.Записать();
					Родитель = НайденнаяСсылка;
				КонецЕсли;
				
	            УзелУр3Child = УзелУр3.childNodes;

				Для Инд3 = 0 по УзелУр3Child.length - 1 Цикл
					// УзелУр4 - это налоговые
					УзелУр4 = УзелУр3Child.item(Инд3);
 					КодРайона = "";
					ИмяРайона = "";
					КодДПИ = "";
					ИмяДПИ = "";
					ТипДПИ = "";
					
					УзелУр4Child = УзелУр4.childNodes;
					
					Для Инд4 = 0 по УзелУр4Child.length - 1 Цикл
						// УзелУр5 - это реквизиты налоговой
						УзелУр5 = УзелУр4Child.item(Инд4);
						Если Врег(УзелУр5.baseName) = ВРег("C_STI") Тогда
							// код ДПИ
							КодДПИ = Строка(УзелУр5.text);
							Если СтрДлина(КодДПИ) = 3 Тогда
								//дополним до 4 символов
								КодДПИ = "0"+КодДПИ;
							КонецЕсли;
						ИначеЕсли Врег(УзелУр5.baseName) = ВРег("T_STI") Тогда
							// тип ДПИ
							ТипДПИ = УзелУр5.text;
						ИначеЕсли Врег(УзелУр5.baseName) = ВРег("NAME_STI") Тогда
							// имя ДПИ
							ИмяДПИ = УзелУр5.text;
						ИначеЕсли Врег(УзелУр5.baseName) = ВРег("C_RAJ") Тогда
							// код района
							КодРайона = Строка(УзелУр5.text);
							Если СтрДлина(КодРайона) = 1 Тогда
								//дополним до 2 символов
								КодРайона = "0"+КодРайона;
							КонецЕсли;
						ИначеЕсли Врег(УзелУр5.baseName) = ВРег( "NAME_RAJ") Тогда
							// имя района
							ИмяРайона = УзелУр5.text;
						КонецЕсли;
					КонецЦикла;
					//Найдем или создадим новую ДПИ
					НайденнаяССылка =  СпрНИ.НайтиПоРеквизиту("КодДляПоиска", КодДПИ+КодРайона);
					Если (НайденнаяСсылка = СпрНИ.ПустаяСсылка()) Тогда
						НовыйЭлемент = СпрНИ.СоздатьЭлемент();
						НовыйЭлемент.Код = КодДПИ;
						НовыйЭлемент.КодАдмРайона = КодРайона;
						НовыйЭлемент.КодДляПоиска = КодДПИ+КодРайона;
					ИначеЕсли НеОбновлять = 1 Тогда
						Продолжить;
					Иначе
						НовыйЭлемент = НайденнаяССылка.ПолучитьОбъект();
					КонецЕсли;
					НовыйЭлемент.Наименование = ИмяДПИ;
					НовыйЭлемент.НаименованиеПолное = ИмяДПИ;
					НовыйЭлемент.НаименованиеАдмРайона = ИмяРайона;
					НовыйЭлемент.ТипДПИ = ТипДПИ;
					НовыйЭлемент.Родитель = Родитель;
					НовыйЭлемент.Записать();
				КонецЦикла;
			КонецЕсли;	
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры
