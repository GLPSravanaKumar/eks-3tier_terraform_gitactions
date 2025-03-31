document.getElementById('registration-form').addEventListener('submit', function (e) {
  e.preventDefault();

  const name = document.getElementById('name').value;
  const email = document.getElementById('email').value;
  const phone = document.getElementById('phone').value;
  const date = document.getElementById('date').value;
  const time = document.getElementById('time').value;

  const data = { name, email, phone, date, time };

  fetch('http://localhost:3000/api/bookings', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
  })
      .then((res) => res.json())
      .then((response) => {
          alert(response.message || 'Booking successful!');
      })
      .catch((err) => {
          console.error(err);
          alert('Error booking the slot!');
      });
});
